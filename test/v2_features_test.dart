import 'dart:convert';
import 'dart:io';

import 'package:belmiad/core/database/app_database.dart';
import 'package:belmiad/core/utilities/scaled_quantity.dart';
import 'package:belmiad/features/health/application/prescription_documents.dart';
import 'package:belmiad/features/health/data/health_repositories.dart';
import 'package:belmiad/features/inventory/data/inventory_repository.dart';
import 'package:belmiad/features/inventory/domain/stock_forecast.dart';
import 'package:belmiad/features/meals/domain/meal_timing.dart';
import 'package:belmiad/features/medications/data/medication_repository.dart';
import 'package:belmiad/features/schedules/data/schedule_repository.dart';
import 'package:belmiad/features/schedules/domain/recurrence_rule.dart';
import 'package:belmiad/core/time/local_date.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_harness.dart';

void main() {
  late TestHarness h;
  late String patientId;
  late String medicationId;

  // Monday 2026-09-28, 06:00 in Cairo (UTC+3).
  setUp(() async {
    h = TestHarness(now: DateTime.utc(2026, 9, 28, 3));
    await h.createCaregiver();
    patientId = await h.createPatient();
    medicationId = await h.createMedication(patientId);
  });

  tearDown(() => h.close());

  Future<Map<String, Meal>> mealsByType() async => {
        for (final m in await h.meals.listForPatient(patientId)) m.mealType: m,
      };

  ScheduleSlot afterMeal(Meal meal, {int quantity = 1000}) => ScheduleSlot(
        scheduleType: ScheduleTypes.mealRelative,
        mealId: meal.mealId,
        timingRelation: timingRelationCode(TimingRelation.after),
        offsetMinutes: 30,
        doseQuantityScaled: quantity,
      );

  Future<List<DoseInstance>> dosesOn(String date) async =>
      (await h.allDoses(patientId)).where((d) => d.localDate == date).toList();

  group('Dose plans', () {
    test('three times a day after meals is set once', () async {
      final meals = await mealsByType();
      final groupId = await h.schedules.saveGroup(
        medicationId: medicationId,
        slots: [
          afterMeal(meals['breakfast']!),
          afterMeal(meals['lunch']!),
          afterMeal(meals['dinner']!, quantity: 2000),
        ],
        rule: const RecurrenceRule(),
      );
      await h.generation.syncPatient(patientId, graceMinutes: 180);

      final schedules = await h.schedules.getGroup(groupId);
      expect(schedules, hasLength(3));
      expect(schedules.every((s) => s.groupId == groupId), isTrue);
      final today = await dosesOn('2026-09-28');
      expect(today, hasLength(3));
      expect(
        today.map((d) => d.scheduledAt.toUtc()),
        [
          DateTime.utc(2026, 9, 28, 5, 30), // 08:30 Cairo
          DateTime.utc(2026, 9, 28, 11, 30), // 14:30
          DateTime.utc(2026, 9, 28, 17, 30), // 20:30
        ],
      );
      expect(today.last.requiredQuantityScaled, 2000);
    });

    test('editing a plan keeps kept times and removes dropped ones', () async {
      final meals = await mealsByType();
      final groupId = await h.schedules.saveGroup(
        medicationId: medicationId,
        slots: [
          afterMeal(meals['breakfast']!),
          afterMeal(meals['lunch']!),
          afterMeal(meals['dinner']!),
        ],
        rule: const RecurrenceRule(),
      );
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      final existing = await h.schedules.getGroup(groupId);
      final breakfast =
          existing.firstWhere((s) => s.mealId == meals['breakfast']!.mealId);

      await h.schedules.saveGroup(
        medicationId: medicationId,
        groupId: groupId,
        slots: [
          ScheduleSlot(
            scheduleId: breakfast.scheduleId,
            scheduleType: ScheduleTypes.mealRelative,
            mealId: breakfast.mealId,
            timingRelation: 'after',
            offsetMinutes: 30,
            doseQuantityScaled: 1000,
          ),
          const ScheduleSlot(
            scheduleType: ScheduleTypes.fixedTime,
            fixedTime: '22:00',
            doseQuantityScaled: 1000,
          ),
        ],
        rule: const RecurrenceRule(),
      );
      await h.generation.syncPatient(
        patientId,
        graceMinutes: 180,
        regenerate: true,
      );
      final after = await h.schedules.getGroup(groupId);
      expect(after, hasLength(2));
      expect(after.map((s) => s.scheduleId), contains(breakfast.scheduleId));
      final tomorrow = await dosesOn('2026-09-29');
      expect(tomorrow, hasLength(2));
    });

    test('an empty plan is rejected', () {
      expect(
        () => h.schedules.saveGroup(
          medicationId: medicationId,
          slots: const [],
          rule: const RecurrenceRule(),
        ),
        throwsA(anything),
      );
    });
  });

  group('Meal times by weekday', () {
    test('breakfast 08:00 on Saturday but 09:00 on Friday', () async {
      final breakfast = (await mealsByType())['breakfast']!;
      await h.meals.update(
        mealId: breakfast.mealId,
        nameEn: breakfast.nameEn,
        nameAr: breakfast.nameAr,
        mealType: breakfast.mealType,
        time: '08:00',
        timeMode: MealTimeModes.weekly,
        weekdayTimes: encodeWeekdayTimes({5: const LocalTime(9, 0)}),
      );
      await h.schedules.saveGroup(
        medicationId: medicationId,
        slots: [afterMeal((await mealsByType())['breakfast']!)],
        rule: const RecurrenceRule(),
      );
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      final friday = (await dosesOn('2026-10-02')).single;
      final saturday = (await dosesOn('2026-10-03')).single;
      expect(friday.scheduledAt.toUtc(), DateTime.utc(2026, 10, 2, 6, 30));
      expect(saturday.scheduledAt.toUtc(), DateTime.utc(2026, 10, 3, 5, 30));
    });

    test('switching back to daily moves future doses', () async {
      final breakfast = (await mealsByType())['breakfast']!;
      await h.schedules.saveGroup(
        medicationId: medicationId,
        slots: [afterMeal(breakfast)],
        rule: const RecurrenceRule(),
      );
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      final changed = await h.meals.update(
        mealId: breakfast.mealId,
        nameEn: breakfast.nameEn,
        nameAr: breakfast.nameAr,
        mealType: breakfast.mealType,
        time: '07:00',
        timeMode: MealTimeModes.daily,
      );
      expect(changed, isTrue);
      await h.generation.syncPatient(
        patientId,
        graceMinutes: 180,
        regenerate: true,
      );
      final friday = (await dosesOn('2026-10-02')).single;
      expect(friday.scheduledAt.toUtc(), DateTime.utc(2026, 10, 2, 4, 30));
    });
  });

  group('Packaging', () {
    test('2 boxes × 3 strips × 10 tablets + 4 loose = 64 tablets', () async {
      expect(
        ScaledQuantity.fromPackages(
          packages: 2,
          subPackagesPerPackage: 3,
          unitsPerPackage: 10,
          loose: ScaledQuantity.units(4),
        ).scaled,
        64000,
      );
      final id = await h.inventory.addBatch(BatchInput.fromPackages(
        medicationId: medicationId,
        packagesCount: 2,
        subPackagesPerPackage: 3,
        subPackagingType: 'strip',
        unitsPerPackage: 10,
        looseQuantityScaled: 4000,
        packagingType: 'box',
      ));
      final batch = await h.batch(id);
      expect(batch.availableQuantityScaled, 64000);
      expect(batch.subPackagesPerPackage, 3);
      expect(batch.subPackagingType, 'strip');
      expect(batch.looseQuantityScaled, 4000);
    });

    test('a bottle of 120 ml without inner packs', () async {
      final id = await h.inventory.addBatch(BatchInput.fromPackages(
        medicationId: medicationId,
        packagesCount: 1,
        unitsPerPackage: 120,
        packagingType: 'bottle',
      ));
      final batch = await h.batch(id);
      expect(batch.availableQuantityScaled, 120000);
      expect(batch.subPackagesPerPackage, isNull);
    });
  });

  group('Storage-only medicines', () {
    test('are stocked without doses, schedules or forecast', () async {
      final storageId = await h.medications.create(
        patientId,
        const MedicationInput(
          nameEn: 'Antinal',
          doseUnit: 'capsule',
          storageOnly: true,
        ),
      );
      await h.schedules.saveGroup(
        medicationId: storageId,
        slots: const [
          ScheduleSlot(
            scheduleType: ScheduleTypes.fixedTime,
            fixedTime: '10:00',
            doseQuantityScaled: 1000,
          ),
        ],
        rule: const RecurrenceRule(),
      );
      await h.inventory.addBatch(
        BatchInput(medicationId: storageId, quantityScaled: 24000),
      );
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      final doses = await h.allDoses(patientId);
      expect(doses.where((d) => d.medicationId == storageId), isEmpty);
      final stock = (await h.forecast.forMedication(storageId))!;
      expect(stock.summary.usableScaled, 24000);
      expect(stock.summary.remainingDays, isNull);
      expect(stock.summary.state, StockState.normal);

      // Starting treatment brings the schedule to life.
      await h.medications.setStorageOnly(storageId, false);
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      final after = await h.allDoses(patientId);
      expect(after.where((d) => d.medicationId == storageId), isNotEmpty);
    });
  });

  group('Vitals context', () {
    test('blood sugar after a meal and blood pressure after medicine',
        () async {
      final vitals = VitalsRepository(h.db, h.audit, clock: h.clock);
      final lunch = (await mealsByType())['lunch']!;
      await vitals.save(
        patientId: patientId,
        measurementType: VitalTypes.bloodGlucose,
        value1: 145,
        measuredAt: h.now,
        context: VitalContexts.afterMeal,
        relatedMealId: lunch.mealId,
        minutesAfter: 120,
      );
      await vitals.save(
        patientId: patientId,
        measurementType: VitalTypes.bloodPressure,
        value1: 130,
        value2: 85,
        measuredAt: h.now,
        context: VitalContexts.afterMedication,
        relatedMedicationId: medicationId,
        minutesAfter: 60,
      );
      await vitals.save(
        patientId: patientId,
        measurementType: VitalTypes.weight,
        value1: 70,
        measuredAt: h.now,
        context: VitalContexts.afterMeal,
        relatedMealId: lunch.mealId,
      );
      final rows = await h.db.select(h.db.vitalsMeasurements).get();
      final glucose =
          rows.firstWhere((r) => r.measurementType == VitalTypes.bloodGlucose);
      expect(glucose.context, VitalContexts.afterMeal);
      expect(glucose.relatedMealId, lunch.mealId);
      expect(glucose.minutesAfter, 120);
      final pressure =
          rows.firstWhere((r) => r.measurementType == VitalTypes.bloodPressure);
      expect(pressure.relatedMedicationId, medicationId);
      expect(pressure.relatedMealId, isNull);
      final weight =
          rows.firstWhere((r) => r.measurementType == VitalTypes.weight);
      expect(weight.context, isNull);
    });
  });

  test('prescription pages combine into a PDF', () async {
    // 1×1 transparent PNG.
    final png = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
    );
    final pdf = await imagesToPdf([png, png]);
    expect(ascii.decode(pdf.take(5).toList()), '%PDF-');
    expect(prescriptionFileKind('a/b.PDF'), PrescriptionFileKind.pdf);
    expect(prescriptionFileKind('a/b.jpeg'), PrescriptionFileKind.image);
  });

  test('a version 1 database is upgraded without losing data', () async {
    final dir = await Directory.systemTemp.createTemp('belmiad_migration');
    final file = File('${dir.path}/v1.sqlite');
    // Build the current schema, then strip the v2 columns to emulate v1.
    var db = AppDatabase(NativeDatabase(file));
    await db.customStatement('SELECT 1');
    await db.into(db.persons).insert(PersonsCompanion.insert(
          personId: 'p1',
          fullName: 'Mother',
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
        ));
    const dropped = {
      'medications': ['storage_only'],
      'medication_inventory_batches': [
        'sub_packaging_type',
        'sub_packages_per_package',
        'loose_quantity_scaled',
      ],
      'meals': ['time_mode', 'weekday_times'],
      'medication_schedules': ['group_id'],
      'vitals_measurements': [
        'context',
        'related_meal_id',
        'related_medication_id',
        'minutes_after',
      ],
    };
    for (final entry in dropped.entries) {
      for (final column in entry.value) {
        await db.customStatement(
          'ALTER TABLE ${entry.key} DROP COLUMN $column',
        );
      }
    }
    await db.customStatement('PRAGMA user_version = 1');
    await db.close();

    db = AppDatabase(NativeDatabase(file));
    final person = await db.select(db.persons).getSingle();
    expect(person.fullName, 'Mother');
    for (final entry in dropped.entries) {
      final columns = await db
          .customSelect('PRAGMA table_info(${entry.key})')
          .map((r) => r.read<String>('name'))
          .get();
      expect(columns, containsAll(entry.value));
    }
    await db.close();
    await dir.delete(recursive: true);
  });
}
