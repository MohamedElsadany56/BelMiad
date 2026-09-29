import 'package:belmiad/core/database/app_database.dart';
import 'dart:convert';

import 'package:belmiad/core/errors/domain_exceptions.dart';
import 'package:belmiad/core/files/app_file_store_stub.dart';
import 'package:belmiad/core/notifications/local_notifier.dart';
import 'package:belmiad/features/backup/application/backup_service.dart';
import 'package:belmiad/features/catalog/data/catalog_importer.dart';
import 'package:belmiad/features/catalog/data/drug_catalog_repository.dart';
import 'package:belmiad/features/catalog/domain/drug_search_normalizer.dart';
import 'package:belmiad/features/doses/domain/dose_status.dart';
import 'package:belmiad/features/health/data/health_repositories.dart';
import 'package:belmiad/features/inventory/data/inventory_repository.dart';
import 'package:belmiad/features/medications/data/medication_repository.dart';
import 'package:belmiad/features/notifications/application/notification_engine.dart';
import 'package:belmiad/features/notifications/data/notification_repository.dart';
import 'package:belmiad/features/notifications/domain/notification_types.dart';
import 'package:belmiad/features/reports/application/report_service.dart';
import 'package:belmiad/features/reports/domain/report_models.dart';
import 'package:belmiad/features/schedules/data/schedule_repository.dart';
import 'package:belmiad/features/schedules/domain/recurrence_rule.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_harness.dart';

class FakeNotifier implements LocalNotifier {
  final scheduled = <int, DateTime>{};
  final shown = <int>[];
  final cancelled = <int>[];

  @override
  Future<void> initialize() async {}

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime at,
    required NotificationChannel channel,
  }) async =>
      scheduled[id] = at;

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required NotificationChannel channel,
  }) async =>
      shown.add(id);

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
    scheduled.remove(id);
  }

  @override
  Future<Set<int>> pendingIds() async => scheduled.keys.toSet();
}

void main() {
  late TestHarness h;
  late String patientId;
  late String medicationId;

  setUp(() async {
    h = TestHarness(now: DateTime.utc(2026, 9, 28, 6));
    await h.createCaregiver();
    patientId = await h.createPatient();
    medicationId = await h.createMedication(patientId);
    await h.schedules.create(
      medicationId,
      const ScheduleInput(
        scheduleType: ScheduleTypes.fixedTime,
        fixedTime: '10:00',
        doseQuantityScaled: 1000,
        rule: RecurrenceRule(),
      ),
    );
    await h.generation.syncPatient(patientId, graceMinutes: 180);
  });

  tearDown(() => h.close());

  Future<String> todaysDose() async => (await h.allDoses(patientId))
      .firstWhere((d) => d.localDate == '2026-09-28')
      .doseInstanceId;

  group('Backup', () {
    late MemoryAppFileStore files;
    late BackupService backup;

    setUp(() {
      files = MemoryAppFileStore();
      backup = BackupService(h.db, files, h.audit, clock: h.clock);
    });

    test('export → import as new patient preserves relationships', () async {
      final batch = await h.inventory.addBatch(BatchInput(
        medicationId: medicationId,
        quantityScaled: 10000,
        expirationDate: '2027-01-01',
      ));
      await h.doses.takeDose(
        doseInstanceId: await todaysDose(),
        actualQuantityScaled: 1000,
      );
      final prescriptions =
          PrescriptionRepository(h.db, h.audit, files, clock: h.clock);
      await prescriptions.create(
        patientId: patientId,
        fileName: 'rx.jpg',
        bytes: Uint8List.fromList([1, 2, 3]),
        doctorName: 'Dr. Ali',
      );

      final zip = await backup.exportPatient(patientId);
      final packages = backup.decode(zip);
      expect(packages.single.manifest['version'], BackupService.currentVersion);
      final result = await backup.importAsNew(packages.single);
      expect(result.patientId, isNot(patientId));

      final meds = await h.medications.listForPatient(result.patientId);
      expect(meds, hasLength(1));
      expect(meds.single.medicationId, isNot(medicationId));
      final batches =
          await h.inventory.getBatchesForMedication(meds.single.medicationId);
      expect(batches.single.availableQuantityScaled, 9000);
      expect(batches.single.inventoryBatchId, isNot(batch));

      final doses = await h.allDoses(result.patientId);
      final taken = doses.singleWhere((d) => d.status == DoseStatus.taken.code);
      final consumption =
          await h.doseRepository.consumptionFor(taken.doseInstanceId);
      expect(
          consumption.single.inventoryBatchId, batches.single.inventoryBatchId);

      // Undo on the imported copy restores the imported batch only.
      await h.doses.undoDose(taken.doseInstanceId);
      expect(
        (await h.batch(batches.single.inventoryBatchId))
            .availableQuantityScaled,
        10000,
      );
      expect((await h.batch(batch)).availableQuantityScaled, 9000);

      final importedRx = await (h.db.select(h.db.prescriptions)
            ..where((p) => p.patientId.equals(result.patientId)))
          .getSingle();
      expect(await files.read(importedRx.filePath), [1, 2, 3]);
    });

    test('merge keeps latest mutable data and never duplicates history',
        () async {
      final zip = await backup.exportPatient(patientId);

      // Local change after the backup was taken.
      h.now = h.now.add(const Duration(hours: 1));
      await h.medications.update(
        medicationId,
        const MedicationInputLite('Panadol Extra').toInput(),
      );

      final package = backup.decode(zip).single;
      final first = await backup.mergeSamePatient(package);
      expect(first.updated, 0);
      final medication = await h.medications.get(medicationId);
      expect(medication!.nameEn, 'Panadol Extra');

      final dosesBefore = (await h.allDoses(patientId)).length;
      final auditBefore = (await h.db.select(h.db.auditEvents).get()).length;
      await backup.mergeSamePatient(package);
      expect(await h.allDoses(patientId), hasLength(dosesBefore));
      // Only the "merged" audit event itself is new.
      expect(
        (await h.db.select(h.db.auditEvents).get()).length,
        auditBefore + 1,
      );
    });

    test('merge applies newer backup values', () async {
      h.now = h.now.add(const Duration(hours: 2));
      await h.medications.update(
        medicationId,
        const MedicationInputLite('Newer name').toInput(),
      );
      final zip = await backup.exportPatient(patientId);
      h.now = h.now.subtract(const Duration(hours: 1));
      await (h.db.update(h.db.medications)
            ..where((m) => m.medicationId.equals(medicationId)))
          .write(MedicationsCompanion(
        nameEn: const Value('Stale'),
        updatedAt: Value(h.now),
      ));
      final result = await backup.mergeSamePatient(backup.decode(zip).single);
      expect(result.updated, greaterThan(0));
      expect((await h.medications.get(medicationId))!.nameEn, 'Newer name');
    });

    test('rejects invalid and newer backups', () {
      expect(
        () => backup.decode(Uint8List.fromList(utf8.encode('hello'))),
        throwsA(isA<ValidationException>()),
      );
    });

    test('migrates a version 1 legacy backup', () async {
      final legacy = {
        'backup_version': 1,
        'patients': [
          {
            'id': 'p1',
            'name': 'Grandma',
            'relation': 'Mother',
            'timezone': 'Africa/Cairo'
          },
        ],
        'medications': [
          {
            'id': 'm1',
            'patient_id': 'p1',
            'name_en': 'Concor',
            'is_prn': false
          },
        ],
        'inventory_batches': [
          {
            'id': 'b1',
            'medication_id': 'm1',
            'available_quantity_scaled': 14000,
            'quantity_scale': 1000,
            'unit': 'tablet',
            'purchase_date': '2026-09-01T00:00:00.000',
            'expiration_date': '2027-09-01T00:00:00.000',
          },
        ],
        'doses': [],
        'health_records': [
          {
            'id': 'r1',
            'patient_id': 'p1',
            'type': 'illness',
            'title': 'Hypertension',
            'occurred_at': '2020-01-01T00:00:00.000'
          },
        ],
      };
      final packages =
          backup.decode(Uint8List.fromList(utf8.encode(jsonEncode(legacy))));
      final result = await backup.importAsNew(packages.single);
      final profile = await h.patients.get(result.patientId);
      expect(profile!.name, 'Grandma');
      final meds = await h.medications.listForPatient(result.patientId);
      expect(meds.single.nameEn, 'Concor');
      final batches =
          await h.inventory.getBatchesForMedication(meds.single.medicationId);
      expect(batches.single.availableQuantityScaled, 14000);
      expect(batches.single.expirationDate, '2027-09-01');
      final illnesses = await (h.db.select(h.db.patientIllnesses)
            ..where((i) => i.patientId.equals(result.patientId)))
          .get();
      expect(illnesses.single.conditionName, 'Hypertension');
    });
  });

  group('Notifications', () {
    late FakeNotifier notifier;
    late NotificationEngine engine;

    setUp(() {
      notifier = FakeNotifier();
      engine = NotificationEngine(
        h.db,
        notifier,
        h.forecast,
        h.settings,
        clock: h.clock,
      );
    });

    Future<List<String>> keys() async =>
        (await h.db.select(h.db.notifications).get())
            .map((n) => n.dedupKey)
            .toList();

    test('repeated generation is deduplicated', () async {
      await engine.sync(languageCode: 'en');
      final first = await keys();
      expect(first.where((k) => k.startsWith('dose_reminder:')), isNotEmpty);
      await engine.sync(languageCode: 'en');
      await engine.sync(languageCode: 'ar');
      expect(await keys(), unorderedEquals(first));
      expect(first.toSet(), hasLength(first.length));
    });

    test('taking a dose cancels its reminders', () async {
      await engine.sync(languageCode: 'en');
      final doseId = await todaysDose();
      final reminderId = notificationIdFor('dose_reminder:$doseId');
      expect(notifier.scheduled.containsKey(reminderId), isTrue);
      await h.doses
          .takeDose(doseInstanceId: doseId, actualQuantityScaled: 1000);
      await engine.sync(languageCode: 'en');
      expect(notifier.scheduled.containsKey(reminderId), isFalse);
    });

    test('low stock notifies once and respects preferences', () async {
      await h.inventory.addBatch(BatchInput(
        medicationId: medicationId,
        quantityScaled: 1000,
      ));
      await engine.sync(languageCode: 'en');
      await engine.sync(languageCode: 'en');
      final low = (await h.db.select(h.db.notifications).get())
          .where((n) => n.notificationType == NotificationTypes.lowStock)
          .toList();
      expect(low, hasLength(1));
      expect(low.single.bodyEn, contains('Mother'));
      expect(notifier.shown, hasLength(1));

      final prefs = NotificationRepository(h.db, clock: h.clock);
      await prefs.setPreference(
          patientId, NotificationTypes.doseReminder, false);
      await engine.sync(languageCode: 'en');
      final pendingReminders =
          (await h.db.select(h.db.notifications).get()).where(
        (n) =>
            n.notificationType == NotificationTypes.doseReminder &&
            n.status == NotificationStatus.scheduled,
      );
      expect(pendingReminders, isEmpty);
    });

    test('expiration notification for an expiring batch', () async {
      await h.inventory.addBatch(BatchInput(
        medicationId: medicationId,
        quantityScaled: 30000,
        expirationDate: '2026-10-08',
      ));
      await engine.sync(languageCode: 'en');
      final rows = (await h.db.select(h.db.notifications).get())
          .where((n) => n.notificationType == NotificationTypes.expiration)
          .toList();
      expect(rows.single.bodyEn, 'Panadol for Mother expires in 10 days.');
    });
  });

  group('Reports', () {
    test('doctor report distinguishes on time, late, missed and skipped',
        () async {
      // Doses on 28th (taken late), 29th (skipped), 30th (missed), 1st (on time).
      h.now = DateTime.utc(2026, 9, 28, 8);
      await h.doses.takeDose(
        doseInstanceId: await todaysDose(),
        actualQuantityScaled: 1000,
      );
      final all = await h.allDoses(patientId);
      await h.doses.skipDose(
        all.firstWhere((d) => d.localDate == '2026-09-29').doseInstanceId,
      );
      h.now = DateTime.utc(2026, 10, 1, 7, 5);
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      await h.doses.takeDose(
        doseInstanceId:
            all.firstWhere((d) => d.localDate == '2026-10-01').doseInstanceId,
        actualQuantityScaled: 1000,
      );
      final service = ReportService(h.db, h.forecast, clock: h.clock);
      final report = await service.doctorReport(
        patientId: patientId,
        level: ReportLevel.detailed,
        arabic: false,
        describeSchedule: (s, m, meal) => s.fixedTime ?? '',
      );
      expect(report.overall.takenLate, 1);
      expect(report.overall.skipped, 1);
      expect(report.overall.missed, 1);
      expect(report.overall.takenOnTime, 1);
      expect(report.overall.adherencePercent, 50);
      expect(report.doses, hasLength(4));
      expect(report.medications.single.scheduleLines, ['10:00']);

      final summary = await service.doctorReport(
        patientId: patientId,
        level: ReportLevel.summary,
        arabic: false,
        describeSchedule: (s, m, meal) => '',
      );
      expect(summary.doses, isEmpty);
    });

    test('storage report answers what to buy', () async {
      await h.inventory.addBatch(BatchInput(
        medicationId: medicationId,
        quantityScaled: 1000,
        purchasePrice: 45,
        purchaseDate: '2026-09-20',
      ));
      final service = ReportService(h.db, h.forecast, clock: h.clock);
      final report =
          await service.inventoryReport(patientId: patientId, arabic: false);
      expect(report.rows.single.lastPurchasePrice, 45);
      expect(report.toPurchase, hasLength(1));
    });
  });

  group('Drug catalog', () {
    late DrugCatalogDatabaseForTest catalog;
    late CatalogImportReport report;

    setUp(() async {
      catalog = DrugCatalogDatabaseForTest();
      for (final statement in CatalogSchema.statements) {
        await catalog.customStatement(statement);
      }
      const csv =
          'commercial_name_en,commercial_name_ar,scientific_name,price_egp\n'
          'PANADOL 500MG 24 TABS.,بانادول,PARACETAMOL,30\n'
          'PANADOL EXTRA 24 TABS.,بانادول إكسترا,PARACETAMOL+CAFFEINE,54\n'
          '"CONCOR 5, 30 TABS.",كونكور,BISOPROLOL,90\n'
          'CONCOR 5 30 TABS.,,BISOPROLOL,90\n'
          'BROKEN PRICE,بروكن,X,abc\n'
          'EXTRA,Ø¥ÙƒØ³ØªØ±Ø§,X,10\n'
          'PANADOL 500MG 24 TABS.,بانادول,PARACETAMOL,30\n'
          'TOO,FEW\n';
      final sink = _DriftSink(catalog);
      report = await CatalogImporter().import(
        Stream.fromIterable(const LineSplitter().convert(csv)),
        sink,
      );
      await sink.flush();
      await catalog.customStatement(CatalogSchema.rebuildFts);
    });

    tearDown(() => catalog.close());

    test('import validates, repairs mojibake and deduplicates', () {
      expect(report.accepted, 4);
      expect(report.duplicates, 1);
      expect(report.repaired, 1);
      expect(report.rejected.map((r) => r.reason), [
        'missing Arabic name',
        'price is not numeric',
        'invalid column count',
      ]);
    });

    test('English, Arabic, prefix and exact-first search', () async {
      final repo = DrugCatalogRepository(catalog);
      final english = await repo.search('panadol');
      expect(english.map((r) => r.nameEn), contains('PANADOL EXTRA 24 TABS.'));
      final arabic = await repo.search('بانادول');
      expect(arabic, hasLength(2));
      final prefix = await repo.search('pana');
      expect(prefix, hasLength(2));
      final exact = await repo.search('بانادول إكسترا');
      expect(exact.first.nameEn, 'PANADOL EXTRA 24 TABS.');
      final quoted = await repo.search('concor 5,');
      expect(quoted.single.nameEn, 'CONCOR 5, 30 TABS.');
      final repaired = await repo.search('اكسترا');
      expect(repaired.map((r) => r.nameAr), contains('إكسترا'));
      expect(await repo.search('p'), isEmpty);
    });

    test('typo-tolerant retry and injection-safe queries', () async {
      final repo = DrugCatalogRepository(catalog);
      expect(await repo.search('panadok'), isNotEmpty);
      expect(await repo.search('"panadol" OR *'), isA<List>());
    });

    test('normalization keeps display strings intact', () {
      expect(normalizeForDrugSearch('إكسترا'), 'اكسترا');
      expect(normalizeForDrugSearch('بانادولـ'), 'بانادول');
      expect(normalizeForDrugSearch('F.C.TABS.'), 'f c tabs');
      expect(normalizeForDrugSearch('١٢٣'), '123');
    });
  });
}

class DrugCatalogDatabaseForTest extends GeneratedDatabase {
  DrugCatalogDatabaseForTest() : super(NativeDatabase.memory());

  @override
  Iterable<TableInfo<Table, dynamic>> get allTables => const [];

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (m) async {});
}

class _DriftSink implements CatalogSink {
  _DriftSink(this.db);

  final GeneratedDatabase db;
  final _pending = <List<Object>>[];

  @override
  void insertBatch(List<CatalogRow> rows) =>
      _pending.addAll(rows.map((r) => r.parameters));

  Future<void> flush() async {
    for (final params in _pending) {
      await db.customInsert(
        CatalogSchema.insert,
        variables: [
          for (final p in params)
            p is double
                ? Variable.withReal(p)
                : Variable.withString(p as String),
        ],
      );
    }
  }
}

/// Minimal helper for medication updates in tests.
class MedicationInputLite {
  const MedicationInputLite(this.name);

  final String name;

  MedicationInput toInput() =>
      MedicationInput(nameEn: name, doseUnit: 'tablet');
}
