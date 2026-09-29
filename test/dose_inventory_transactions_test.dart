import 'package:belmiad/core/errors/domain_exceptions.dart';
import 'package:belmiad/features/audit/data/audit_log.dart';
import 'package:belmiad/features/doses/domain/dose_status.dart';
import 'package:belmiad/features/inventory/data/inventory_repository.dart';
import 'package:belmiad/features/inventory/domain/batch_selection.dart';
import 'package:belmiad/features/inventory/domain/stock_forecast.dart';
import 'package:belmiad/features/meals/domain/meal_timing.dart';
import 'package:belmiad/features/medications/data/medication_repository.dart';
import 'package:belmiad/features/patients/data/patient_repository.dart';
import 'package:belmiad/features/schedules/data/schedule_repository.dart';
import 'package:belmiad/features/schedules/domain/recurrence_rule.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_harness.dart';

void main() {
  late TestHarness h;
  late String patientId;
  late String medicationId;

  // 2026-09-28 09:00 in Cairo (UTC+3).
  setUp(() async {
    h = TestHarness(now: DateTime.utc(2026, 9, 28, 6));
    await h.createCaregiver();
    patientId = await h.createPatient();
    medicationId = await h.createMedication(patientId);
  });

  tearDown(() => h.close());

  Future<String> addSchedule({
    String time = '10:00',
    int quantity = 1000,
    RecurrenceRule rule = const RecurrenceRule(),
  }) async {
    final id = await h.schedules.create(
      medicationId,
      ScheduleInput(
        scheduleType: ScheduleTypes.fixedTime,
        fixedTime: time,
        doseQuantityScaled: quantity,
        rule: rule,
      ),
    );
    await h.generation.syncPatient(patientId, graceMinutes: 180);
    return id;
  }

  Future<String> addBatch(int units, {String? expires, String? purchased}) =>
      h.inventory.addBatch(BatchInput(
        medicationId: medicationId,
        quantityScaled: units * 1000,
        expirationDate: expires,
        purchaseDate: purchased,
      ));

  Future<String> todaysDoseId() async {
    final doses = await h.allDoses(patientId);
    return doses.firstWhere((d) => d.localDate == '2026-09-28').doseInstanceId;
  }

  group('Dose generation', () {
    test('generates future doses once, deterministically', () async {
      await addSchedule();
      final first = await h.allDoses(patientId);
      expect(first, isNotEmpty);
      expect(first.first.scheduledAt.toUtc(), DateTime.utc(2026, 9, 28, 7));
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      expect(await h.allDoses(patientId), hasLength(first.length));
    });

    test('does not fabricate doses before the schedule existed', () async {
      await addSchedule(time: '08:00');
      final doses = await h.allDoses(patientId);
      expect(doses.any((d) => d.localDate == '2026-09-28'), isFalse);
    });

    test('overdue doses become MISSED and cannot be taken', () async {
      await addSchedule();
      final id = await todaysDoseId();
      h.now = DateTime.utc(2026, 9, 28, 11);
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      final dose = await h.dose(id);
      expect(dose.status, DoseStatus.missed.code);
      expect(
        () => h.doses.takeDose(doseInstanceId: id, actualQuantityScaled: 1000),
        throwsA(isA<InvalidDoseTransitionException>()),
      );
    });

    test('changing a meal time moves meal-relative doses', () async {
      final meals = await h.meals.listForPatient(patientId);
      final lunch = meals.firstWhere((m) => m.mealType == 'lunch');
      await h.schedules.create(
        medicationId,
        ScheduleInput(
          scheduleType: ScheduleTypes.mealRelative,
          mealId: lunch.mealId,
          timingRelation: timingRelationCode(TimingRelation.after),
          offsetMinutes: 45,
          doseQuantityScaled: 1000,
          rule: const RecurrenceRule(),
        ),
      );
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      var dose = (await h.allDoses(patientId)).first;
      // 14:45 Cairo = 11:45 UTC.
      expect(dose.scheduledAt.toUtc(), DateTime.utc(2026, 9, 28, 11, 45));

      await h.meals.update(
        mealId: lunch.mealId,
        nameEn: lunch.nameEn,
        nameAr: lunch.nameAr,
        mealType: lunch.mealType,
        time: '13:00',
      );
      await h.generation.syncPatient(
        patientId,
        graceMinutes: 180,
        regenerate: true,
      );
      dose = (await h.allDoses(patientId)).first;
      expect(dose.scheduledAt.toUtc(), DateTime.utc(2026, 9, 28, 10, 45));
    });

    test('timezone change keeps the same local clock time', () async {
      await addSchedule(time: '20:00');
      final profile = (await h.patients.get(patientId))!;
      await h.patients.update(
        patientId,
        PatientInput(fullName: profile.name, timezone: 'Asia/Dubai'),
      );
      await h.generation.syncPatient(
        patientId,
        graceMinutes: 180,
        regenerate: true,
      );
      final dose = (await h.allDoses(patientId))
          .firstWhere((d) => d.localDate == '2026-09-28');
      // 20:00 in Dubai (UTC+4) = 16:00 UTC.
      expect(dose.scheduledAt.toUtc(), DateTime.utc(2026, 9, 28, 16));
    });

    test('medication end date stops generation', () async {
      await h.medications.update(
        medicationId,
        const MedicationInput(
          nameEn: 'Panadol',
          doseUnit: 'tablet',
          endDate: '2026-09-29',
        ),
      );
      await addSchedule();
      final doses = await h.allDoses(patientId);
      expect(
          doses.map((d) => d.localDate).toSet(), {'2026-09-28', '2026-09-29'});
    });
  });

  group('Taking doses', () {
    test('medication without inventory can be taken without consumption',
        () async {
      await addSchedule();
      final id = await todaysDoseId();
      h.now = DateTime.utc(2026, 9, 28, 7, 40);
      await h.doses.takeDose(doseInstanceId: id, actualQuantityScaled: 1000);
      final dose = await h.dose(id);
      expect(dose.status, DoseStatus.taken.code);
      expect(dose.lateMinutes, 40);
      expect(dose.loggedByPersonId, h.session.actorPersonId);
      expect(await h.doseRepository.consumptionFor(id), isEmpty);
    });

    test('FEFO consumption across multiple batches and exact undo', () async {
      await addSchedule(quantity: 5000);
      final a = await addBatch(2, expires: '2026-10-01');
      final b = await addBatch(10, expires: '2027-02-01');
      final id = await todaysDoseId();
      await h.doses.takeDose(doseInstanceId: id, actualQuantityScaled: 5000);

      expect((await h.batch(a)).availableQuantityScaled, 0);
      expect((await h.batch(a)).isDepleted, isTrue);
      expect((await h.batch(b)).availableQuantityScaled, 7000);
      final consumption = await h.doseRepository.consumptionFor(id);
      expect(
        {for (final c in consumption) c.inventoryBatchId: c.quantityScaled},
        {a: 2000, b: 3000},
      );

      await h.doses.undoDose(id);
      expect((await h.batch(a)).availableQuantityScaled, 2000);
      expect((await h.batch(a)).isDepleted, isFalse);
      expect((await h.batch(b)).availableQuantityScaled, 10000);
      final dose = await h.dose(id);
      expect(dose.status, DoseStatus.scheduled.code);
      expect(dose.takenAt, isNull);
      expect(dose.actualQuantityScaled, isNull);
      expect(dose.lateMinutes, isNull);
      final reversed = await h.doseRepository.consumptionFor(id);
      expect(reversed.every((c) => c.reversedAt != null), isTrue);

      // Undoing twice is rejected and does not touch stock.
      expect(
        () => h.doses.undoDose(id),
        throwsA(isA<InvalidDoseTransitionException>()),
      );
      expect((await h.batch(b)).availableQuantityScaled, 10000);
    });

    test('expired stock is never selected automatically', () async {
      await addSchedule(quantity: 2000);
      await addBatch(50, expires: '2026-09-01');
      final good = await addBatch(1, expires: '2027-01-01');
      final id = await todaysDoseId();
      final context = await h.doses.prepareTake(id);
      expect(context.isInsufficient, isTrue);
      expect(context.usableScaled, 1000);
      expect(
        () => h.doses.takeDose(doseInstanceId: id, actualQuantityScaled: 2000),
        throwsA(isA<InsufficientStockException>()),
      );
      // Partial dose: user took what was available.
      await h.doses.takeDose(doseInstanceId: id, actualQuantityScaled: 1000);
      final dose = await h.dose(id);
      expect(dose.status, DoseStatus.taken.code);
      expect(dose.requiredQuantityScaled, 2000);
      expect(dose.actualQuantityScaled, 1000);
      expect((await h.batch(good)).availableQuantityScaled, 0);
    });

    test('zero actual quantity is never TAKEN and consumes nothing', () async {
      await addSchedule();
      final batch = await addBatch(10);
      final id = await todaysDoseId();
      expect(
        () => h.doses.takeDose(doseInstanceId: id, actualQuantityScaled: 0),
        throwsA(isA<ValidationException>()),
      );
      expect((await h.dose(id)).status, DoseStatus.scheduled.code);
      expect((await h.batch(batch)).availableQuantityScaled, 10000);
    });

    test('fractional quantities', () async {
      await addSchedule(quantity: 250);
      final batch = await addBatch(1);
      final id = await todaysDoseId();
      await h.doses.takeDose(doseInstanceId: id, actualQuantityScaled: 250);
      expect((await h.batch(batch)).availableQuantityScaled, 750);
    });

    test('manual batch selection is honoured and audited', () async {
      await addSchedule(quantity: 2000);
      await addBatch(10, expires: '2026-10-15');
      final later = await addBatch(10, expires: '2027-10-15');
      final id = await todaysDoseId();
      await h.doses.takeDose(
        doseInstanceId: id,
        actualQuantityScaled: 2000,
        manualAllocations: [
          BatchAllocation(batchId: later, quantityScaled: 2000),
        ],
      );
      expect((await h.batch(later)).availableQuantityScaled, 8000);
      final audit = await (h.db.select(h.db.auditEvents)
            ..where((a) => a.action.equals(AuditActions.batchManuallySelected)))
          .get();
      expect(audit, hasLength(1));
      expect(audit.single.actorPersonId, h.session.actorPersonId);
    });

    test('skipped doses consume nothing and are terminal', () async {
      await addSchedule();
      final batch = await addBatch(5);
      final id = await todaysDoseId();
      await h.doses.skipDose(id);
      expect((await h.dose(id)).status, DoseStatus.skipped.code);
      expect((await h.batch(batch)).availableQuantityScaled, 5000);
      expect(
        () => h.doses.takeDose(doseInstanceId: id, actualQuantityScaled: 1000),
        throwsA(isA<InvalidDoseTransitionException>()),
      );
    });

    test('a failure half-way rolls back everything', () async {
      await addSchedule(quantity: 2000);
      final a = await addBatch(1, expires: '2026-10-01');
      final b = await addBatch(5, expires: '2027-10-01');
      final id = await todaysDoseId();
      // Consumption rows and stock decrements succeed, then marking the dose
      // TAKEN fails inside the same transaction.
      await h.db.customStatement(
        "CREATE TRIGGER fail_taken BEFORE UPDATE ON dose_instances "
        "WHEN NEW.status = 'TAKEN' BEGIN SELECT RAISE(ABORT, 'boom'); END",
      );
      await expectLater(
        h.doses.takeDose(doseInstanceId: id, actualQuantityScaled: 2000),
        throwsA(anything),
      );
      expect((await h.batch(a)).availableQuantityScaled, 1000);
      expect((await h.batch(b)).availableQuantityScaled, 5000);
      expect((await h.dose(id)).status, DoseStatus.scheduled.code);
      expect(await h.doseRepository.consumptionFor(id), isEmpty);
    });
  });

  group('PRN and maximum daily quantity', () {
    setUp(() async {
      medicationId = await h.createMedication(
        patientId,
        name: 'Ibuprofen',
        prn: true,
        maximumDailyScaled: 4000,
      );
    });

    test('PRN doses are logged when taken and never generated', () async {
      await addSchedule();
      final generated = await h.allDoses(patientId);
      expect(generated.where((d) => d.medicationId == medicationId), isEmpty);
      await addBatch(20);
      final id = await h.doses.logPrnDose(
        medicationId: medicationId,
        actualQuantityScaled: 1000,
      );
      final dose = await h.dose(id);
      expect(dose.isPrn, isTrue);
      expect(dose.status, DoseStatus.taken.code);
    });

    test('warns when the maximum would be exceeded; override is audited',
        () async {
      await addBatch(20);
      await h.doses.logPrnDose(
        medicationId: medicationId,
        actualQuantityScaled: 3000,
      );
      expect(
        () => h.doses.logPrnDose(
          medicationId: medicationId,
          actualQuantityScaled: 2000,
        ),
        throwsA(
          isA<MaximumDailyQuantityExceededException>()
              .having((e) => e.alreadyTakenScaled, 'taken', 3000)
              .having((e) => e.maximumScaled, 'max', 4000),
        ),
      );
      await h.doses.logPrnDose(
        medicationId: medicationId,
        actualQuantityScaled: 2000,
        overrideMaximum: true,
      );
      final overrides = await (h.db.select(h.db.auditEvents)
            ..where((a) => a.action.equals(AuditActions.maximumOverridden)))
          .get();
      expect(overrides, hasLength(1));
    });
  });

  group('Inventory ledger', () {
    test('stock adjustments are recorded and never go negative', () async {
      final batch = await addBatch(10);
      await h.inventory.adjustQuantity(
        batchId: batch,
        deltaScaled: -3000,
        reason: 'damaged',
      );
      expect((await h.batch(batch)).availableQuantityScaled, 7000);
      expect(
        () => h.inventory.adjustQuantity(
          batchId: batch,
          deltaScaled: -8000,
          reason: 'lost',
        ),
        throwsA(isA<NegativeStockException>()),
      );
      final adjustments = await h.db.select(h.db.inventoryAdjustments).get();
      expect(adjustments.single.previousQuantityScaled, 10000);
      expect(adjustments.single.newQuantityScaled, 7000);
      expect(adjustments.single.actorPersonId, h.session.actorPersonId);
    });

    test('quantities with history must be changed through adjustments',
        () async {
      final batch = await addBatch(10);
      await h.inventory.adjustQuantity(
        batchId: batch,
        deltaScaled: 1000,
        reason: 'count_correction',
      );
      expect(
        () => h.inventory.updateBatch(
          batch,
          BatchInput(medicationId: medicationId, quantityScaled: 50000),
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('forecast states: not recorded, low, depleted', () async {
      await addSchedule(quantity: 1000);
      var stock = (await h.forecast.forMedication(medicationId))!;
      expect(stock.summary.state, StockState.noStockRecorded);
      final batch = await addBatch(2);
      stock = (await h.forecast.forMedication(medicationId))!;
      expect(stock.summary.state, StockState.low);
      await h.inventory.adjustQuantity(
        batchId: batch,
        deltaScaled: -2000,
        reason: 'lost',
      );
      stock = (await h.forecast.forMedication(medicationId))!;
      expect(stock.summary.state, StockState.empty);
      expect((await h.batch(batch)).isDepleted, isTrue);
    });

    test('deleted batch goes to trash, can be restored', () async {
      final batch = await addBatch(5);
      await h.trash.moveToTrash(
        entityType: EntityTypes.inventoryBatch,
        entityId: batch,
        patientId: patientId,
        label: 'Panadol batch',
      );
      expect(await h.inventory.getBatchesForMedication(medicationId), isEmpty);
      final item =
          (await h.trash.watchActive(patientId: patientId).first).single;
      await h.trash.restore(item.trashItemId);
      expect(await h.inventory.getBatchesForMedication(medicationId),
          hasLength(1));
    });
  });

  group('Patients, caregivers and trash', () {
    test('patient isolation and trash/restore', () async {
      final other = await h.createPatient('Father');
      await h.createMedication(other, name: 'Concor');
      expect(await h.medications.listForPatient(patientId), hasLength(1));
      expect(await h.medications.listForPatient(other), hasLength(1));

      await h.trash.moveToTrash(
        entityType: EntityTypes.patient,
        entityId: other,
        patientId: other,
        label: 'Father',
      );
      expect((await h.patients.listActive()).map((p) => p.id), [patientId]);
      final item = (await h.trash.watchActive().first).single;
      await h.trash.restore(item.trashItemId);
      expect(await h.patients.listActive(), hasLength(2));
    });

    test('permanent delete removes the patient but keeps other data', () async {
      final other = await h.createPatient('Father');
      await h.createMedication(other, name: 'Concor');
      await h.trash.moveToTrash(
        entityType: EntityTypes.patient,
        entityId: other,
        patientId: other,
        label: 'Father',
      );
      final item = (await h.trash.watchActive().first).single;
      await h.trash.permanentlyDelete(item.trashItemId);
      expect(await h.patients.get(other), isNull);
      expect(await h.medications.listForPatient(other), isEmpty);
      expect(await h.medications.listForPatient(patientId), hasLength(1));
    });

    test('removing a caregiver keeps the historical actor', () async {
      await addSchedule();
      final id = await todaysDoseId();
      await h.doses.takeDose(doseInstanceId: id, actualQuantityScaled: 1000);
      final caregiverId = h.session.actorPersonId!;
      final links = await h.caregivers.watchAssignments(patientId).first;
      await h.caregivers.removeAssignment(links.single.assignment.assignmentId);
      expect(await h.caregivers.watchAssignments(patientId).first, isEmpty);
      final dose = await h.dose(id);
      expect(dose.loggedByPersonId, caregiverId);
      expect(
          (await h.caregivers.getPerson(caregiverId))!.fullName, 'Nurse Sara');
    });
  });
}
