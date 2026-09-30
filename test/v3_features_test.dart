import 'dart:io';

import 'package:belmiad/core/database/app_database.dart';
import 'package:belmiad/core/errors/domain_exceptions.dart';
import 'package:belmiad/features/audit/data/audit_log.dart';
import 'package:belmiad/features/doses/domain/dose_status.dart';
import 'package:belmiad/features/inventory/data/inventory_repository.dart';
import 'package:belmiad/features/inventory/domain/partial_pack.dart';
import 'package:belmiad/features/schedules/data/schedule_repository.dart';
import 'package:belmiad/features/schedules/domain/recurrence_rule.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_harness.dart';

void main() {
  late TestHarness h;
  late String patientId;
  late String medicationId;

  // 2026-09-28 06:00 UTC = 09:00 Cairo (UTC+3).
  setUp(() async {
    h = TestHarness(now: DateTime.utc(2026, 9, 28, 6));
    await h.createCaregiver();
    patientId = await h.createPatient();
    medicationId = await h.createMedication(patientId);
  });

  tearDown(() => h.close());

  group('Opened / incomplete packs', () {
    test('a full box plus a strip with 9 of 14 left', () async {
      final id = await h.inventory.addBatch(BatchInput.fromPackages(
        medicationId: medicationId,
        packagesCount: 1,
        subPackagesPerPackage: 2,
        subPackagingType: 'strip',
        unitsPerPackage: 14,
        packagingType: 'box',
        partialPacks: const [
          PartialPack(type: 'strip', remainingScaled: 9000, capacity: 14),
        ],
      ));
      final batch = await h.batch(id);
      expect(batch.availableQuantityScaled, 37000);
      expect(decodePartialPacks(batch.partialPacksJson), const [
        PartialPack(type: 'strip', remainingScaled: 9000, capacity: 14),
      ]);
    });

    test('only an opened strip and a half-used bottle', () async {
      final id = await h.inventory.addBatch(BatchInput.fromPackages(
        medicationId: medicationId,
        packagesCount: 0,
        unitsPerPackage: 0,
        packagingType: 'strip',
        partialPacks: const [
          PartialPack(type: 'strip', remainingScaled: 9000, capacity: 14),
          PartialPack(type: 'strip', remainingScaled: 2500),
        ],
      ));
      expect((await h.batch(id)).availableQuantityScaled, 11500);
    });

    test('remaining units cannot exceed the pack capacity', () {
      expect(
        () => h.inventory.addBatch(BatchInput.fromPackages(
          medicationId: medicationId,
          packagesCount: 0,
          unitsPerPackage: 0,
          partialPacks: const [
            PartialPack(type: 'strip', remainingScaled: 15000, capacity: 14),
          ],
        )),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('Recording a dose the patient took earlier', () {
    Future<String> scheduleAt(String time) async {
      await h.schedules.create(
        medicationId,
        ScheduleInput(
          scheduleType: ScheduleTypes.fixedTime,
          fixedTime: time,
          doseQuantityScaled: 1000,
          rule: const RecurrenceRule(),
        ),
      );
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      return (await h.allDoses(patientId))
          .firstWhere((d) => d.localDate == '2026-09-28')
          .doseInstanceId;
    }

    test('stores the intake time and when it was recorded', () async {
      final doseId = await scheduleAt('10:00'); // 07:00 UTC
      final batch = await h.inventory.addBatch(
        BatchInput(medicationId: medicationId, quantityScaled: 10000),
      );
      // Caregiver arrives at 11:30 Cairo; patient took it at 10:20.
      h.now = DateTime.utc(2026, 9, 28, 8, 30);
      await h.doses.takeDose(
        doseInstanceId: doseId,
        actualQuantityScaled: 1000,
        takenAt: DateTime.utc(2026, 9, 28, 7, 20),
      );
      final dose = await h.dose(doseId);
      expect(dose.status, DoseStatus.taken.code);
      expect(dose.takenAt!.toUtc(), DateTime.utc(2026, 9, 28, 7, 20));
      expect(dose.loggedAt!.toUtc(), DateTime.utc(2026, 9, 28, 8, 30));
      expect(dose.lateMinutes, 20);
      expect(isRecordedLater(dose.takenAt!, dose.loggedAt!), isTrue);
      expect((await h.batch(batch)).availableQuantityScaled, 9000);
      final audit = await h.db.select(h.db.auditEvents).get();
      expect(
        audit.map((a) => a.action),
        contains(AuditActions.doseRecordedLate),
      );
    });

    test('a dose auto-marked missed can be corrected with the real time',
        () async {
      final doseId = await scheduleAt('10:00'); // 07:00 UTC
      // Nobody opened the app; at 14:00 Cairo the dose is marked missed.
      h.now = DateTime.utc(2026, 9, 28, 11);
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      expect((await h.dose(doseId)).status, DoseStatus.missed.code);

      // Taking it "now" is still impossible.
      await expectLater(
        h.doses.takeDose(doseInstanceId: doseId, actualQuantityScaled: 1000),
        throwsA(isA<InvalidDoseTransitionException>()),
      );
      // Recording the real intake time (10:05) corrects it.
      await h.doses.takeDose(
        doseInstanceId: doseId,
        actualQuantityScaled: 1000,
        takenAt: DateTime.utc(2026, 9, 28, 7, 5),
      );
      final dose = await h.dose(doseId);
      expect(dose.status, DoseStatus.taken.code);
      expect(dose.missedAt, isNull);
      expect(dose.lateMinutes, 5);

      // A later sync does not mark it missed again.
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      expect((await h.dose(doseId)).status, DoseStatus.taken.code);
    });

    test('an intake outside the allowed window is rejected', () async {
      final doseId = await scheduleAt('10:00'); // 07:00 UTC
      h.now = DateTime.utc(2026, 9, 28, 12);
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      // After the grace window: still a real missed dose.
      await expectLater(
        h.doses.takeDose(
          doseInstanceId: doseId,
          actualQuantityScaled: 1000,
          graceMinutes: 180,
          takenAt: DateTime.utc(2026, 9, 28, 10, 30),
        ),
        throwsA(isA<DoseWindowClosedException>()),
      );
      // In the future.
      await expectLater(
        h.doses.takeDose(
          doseInstanceId: doseId,
          actualQuantityScaled: 1000,
          takenAt: DateTime.utc(2026, 9, 28, 13),
        ),
        throwsA(
          isA<ValidationException>()
              .having((e) => e.code, 'code', 'takenInFuture'),
        ),
      );
      // Too long before the scheduled time.
      await expectLater(
        h.doses.takeDose(
          doseInstanceId: doseId,
          actualQuantityScaled: 1000,
          takenAt: DateTime.utc(2026, 9, 27, 12),
        ),
        throwsA(
          isA<ValidationException>()
              .having((e) => e.code, 'code', 'takenTooEarly'),
        ),
      );
      expect((await h.dose(doseId)).status, DoseStatus.missed.code);
    });

    test('an as-needed dose can be logged at an earlier time', () async {
      final prnId = await h.createMedication(
        patientId,
        name: 'Ibuprofen',
        prn: true,
      );
      h.now = DateTime.utc(2026, 9, 28, 20); // 23:00 Cairo
      final id = await h.doses.logPrnDose(
        medicationId: prnId,
        actualQuantityScaled: 1000,
        takenAt: DateTime.utc(2026, 9, 28, 12), // 15:00 Cairo
      );
      final dose = await h.dose(id);
      expect(dose.takenAt!.toUtc(), DateTime.utc(2026, 9, 28, 12));
      expect(dose.scheduledAt.toUtc(), DateTime.utc(2026, 9, 28, 12));
      expect(dose.localDate, '2026-09-28');
    });
  });

  test('a version 2 database gains the version 3 columns', () async {
    final dir = await Directory.systemTemp.createTemp('belmiad_v3');
    final file = File('${dir.path}/v2.sqlite');
    var db = AppDatabase(NativeDatabase(file));
    await db.customStatement('SELECT 1');
    await db.customStatement(
      'ALTER TABLE medication_inventory_batches DROP COLUMN partial_packs_json',
    );
    await db.customStatement('ALTER TABLE dose_instances DROP COLUMN logged_at');
    await db.customStatement('PRAGMA user_version = 2');
    await db.close();

    db = AppDatabase(NativeDatabase(file));
    Future<List<String>> columns(String table) => db
        .customSelect('PRAGMA table_info($table)')
        .map((r) => r.read<String>('name'))
        .get();
    expect(
      await columns('medication_inventory_batches'),
      contains('partial_packs_json'),
    );
    expect(await columns('dose_instances'), contains('logged_at'));
    await db.close();
    await dir.delete(recursive: true);
  });
}
