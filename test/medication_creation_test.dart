import 'package:belmiad/features/inventory/data/inventory_repository.dart';
import 'package:belmiad/features/meals/domain/meal_timing.dart';
import 'package:belmiad/features/medications/data/medication_repository.dart';
import 'package:belmiad/features/schedules/data/schedule_repository.dart';
import 'package:belmiad/features/schedules/domain/recurrence_rule.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_harness.dart';

void main() {
  late TestHarness h;
  late String patientId;

  setUp(() async {
    h = TestHarness(now: DateTime.utc(2026, 9, 28, 6));
    await h.createCaregiver();
    patientId = await h.createPatient();
  });

  tearDown(() => h.close());

  test('a medication can exist with no inventory and no schedule', () async {
    final id = await h.createMedication(patientId);
    final med = await h.medications.listForPatient(patientId);
    expect(med.map((m) => m.medicationId), [id]);
    expect(await h.allDoses(patientId), isEmpty);
  });

  test('stock can be added later to the same medication', () async {
    final id = await h.createMedication(patientId);
    final batch = await h.inventory.addBatch(
      BatchInput(medicationId: id, quantityScaled: 10000, unitsPerPackage: 10),
    );
    expect((await h.batch(batch)).availableQuantityScaled, 10000);
  });

  test('multiple schedules (fixed time and meal relative) generate doses',
      () async {
    final id = await h.createMedication(patientId);
    final lunch = (await h.meals.listForPatient(patientId))
        .firstWhere((m) => m.mealType == 'lunch');
    await h.schedules.saveGroup(
      medicationId: id,
      slots: [
        const ScheduleSlot(
          scheduleType: ScheduleTypes.fixedTime,
          fixedTime: '10:00',
          doseQuantityScaled: 1000,
        ),
        ScheduleSlot(
          scheduleType: ScheduleTypes.mealRelative,
          mealId: lunch.mealId,
          timingRelation: timingRelationCode(TimingRelation.after),
          offsetMinutes: 30,
          doseQuantityScaled: 1000,
        ),
      ],
      rule: const RecurrenceRule(),
    );
    await h.generation.syncPatient(patientId, graceMinutes: 180);
    final today = (await h.allDoses(patientId))
        .where((d) => d.localDate == '2026-09-28')
        .toList();
    expect(today.length, 2);
  });

  test('findDuplicate matches by name, strength and unit', () async {
    final id = await h.createMedication(patientId, name: 'Panadol');
    const same = MedicationInput(
      nameEn: ' panadol ',
      doseUnit: 'tablet',
      strength: '500 MG',
    );
    expect(
        (await h.medications.findDuplicate(patientId, same))?.medicationId, id);
    const otherStrength = MedicationInput(
      nameEn: 'Panadol',
      doseUnit: 'tablet',
      strength: '1000 mg',
    );
    expect(await h.medications.findDuplicate(patientId, otherStrength), isNull);
    expect(
      await h.medications
          .findDuplicate(patientId, same, excludeMedicationId: id),
      isNull,
    );
  });
}
