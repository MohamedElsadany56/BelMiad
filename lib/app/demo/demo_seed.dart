import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/settings/settings_repository.dart';
import '../../core/utilities/scaled_quantity.dart';
import '../../features/health/data/health_repositories.dart';
import '../../features/inventory/data/inventory_repository.dart';
import '../../features/inventory/domain/partial_pack.dart';
import '../../features/meals/domain/meal_timing.dart';
import '../../features/medications/data/medication_repository.dart';
import '../../features/patients/data/patient_repository.dart';
import '../../features/schedules/data/schedule_repository.dart';
import '../../features/schedules/domain/recurrence_rule.dart';
import '../providers/app_providers.dart';

/// Demo data for screenshots and walkthroughs. Only compiled into builds made
/// with `--dart-define=BELMIAD_DEMO=true`; normal builds never include it.
const demoMode = bool.fromEnvironment('BELMIAD_DEMO');

/// Seeds demo data once at startup in demo builds.
final demoSeedProvider = FutureProvider<void>((ref) => seedDemoData(ref));

/// Seeds a realistic patient profile when the database is empty.
Future<void> seedDemoData(Ref ref) async {
  final db = ref.read(databaseProvider);
  if ((await db.select(db.patients).get()).isNotEmpty) return;

  final caregivers = ref.read(caregiverRepositoryProvider);
  final settings = ref.read(settingsRepositoryProvider);
  final sara = await caregivers.createPerson(fullName: 'Sara Hassan');
  await caregivers.setDeviceCaregiver(sara);
  ref.read(sessionProvider).actorPersonId = sara;

  final patients = ref.read(patientRepositoryProvider);
  final mother = await patients.create(
    const PatientInput(
      fullName: 'Mother',
      dateOfBirth: '1958-04-12',
      sex: 'female',
      bloodType: 'A+',
      emergencyContactName: 'Sara Hassan',
      emergencyContactPhone: '+20 100 000 0000',
    ),
    caregiverPersonId: sara,
    relationship: 'Daughter',
  );
  await patients.create(
    const PatientInput(fullName: 'Father', dateOfBirth: '1954-09-02'),
    caregiverPersonId: sara,
    relationship: 'Son',
  );
  await settings.set(SettingKeys.currentPatientId, mother);

  final meals = {
    for (final m
        in await ref.read(mealRepositoryProvider).listForPatient(mother))
      m.mealType: m,
  };
  final medications = ref.read(medicationRepositoryProvider);
  final schedules = ref.read(scheduleRepositoryProvider);
  final inventory = ref.read(inventoryRepositoryProvider);
  final today = DateTime.now();
  String isoIn(int days) {
    final d = today.add(Duration(days: days));
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  ScheduleSlot meal(String type, TimingRelation relation, {int offset = 30}) =>
      ScheduleSlot(
        scheduleType: ScheduleTypes.mealRelative,
        mealId: meals[type]!.mealId,
        timingRelation: timingRelationCode(relation),
        offsetMinutes: relation == TimingRelation.withMeal ? null : offset,
        doseQuantityScaled: quantityScale,
      );

  // Metformin: after breakfast and dinner; a box plus an opened strip.
  final metformin = await medications.create(
    mother,
    const MedicationInput(
      nameEn: 'Glucophage',
      nameAr: 'جلوكوفاج',
      strength: '500 mg',
      doseUnit: 'tablet',
      instructionsEn: 'Take after meals with a full glass of water.',
      instructionsAr: 'يؤخذ بعد الأكل مع كوب ماء كامل.',
    ),
  );
  await schedules.saveGroup(
    medicationId: metformin,
    slots: [
      meal('breakfast', TimingRelation.after),
      meal('dinner', TimingRelation.after),
    ],
    rule: const RecurrenceRule(),
  );
  await inventory.addBatch(BatchInput.fromPackages(
    medicationId: metformin,
    packagesCount: 1,
    subPackagesPerPackage: 3,
    subPackagingType: 'strip',
    unitsPerPackage: 10,
    packagingType: 'box',
    partialPacks: const [
      PartialPack(type: 'strip', remainingScaled: 7000, capacity: 10),
    ],
    purchaseDate: isoIn(-10),
    purchasePrice: 48,
    expirationDate: isoIn(400),
  ));

  // Concor: every morning; stock expiring soon.
  final concor = await medications.create(
    mother,
    const MedicationInput(
      nameEn: 'Concor',
      nameAr: 'كونكور',
      strength: '5 mg',
      doseUnit: 'tablet',
    ),
  );
  await schedules.saveGroup(
    medicationId: concor,
    slots: const [
      ScheduleSlot(
        scheduleType: ScheduleTypes.fixedTime,
        fixedTime: '08:00',
        doseQuantityScaled: quantityScale,
      ),
    ],
    rule: const RecurrenceRule(),
  );
  await inventory.addBatch(BatchInput.fromPackages(
    medicationId: concor,
    packagesCount: 1,
    subPackagesPerPackage: 2,
    subPackagingType: 'strip',
    unitsPerPackage: 14,
    packagingType: 'box',
    purchaseDate: isoIn(-20),
    purchasePrice: 95,
    expirationDate: isoIn(18),
  ));

  // Omeprazole: before breakfast; running low.
  final omeprazole = await medications.create(
    mother,
    const MedicationInput(
      nameEn: 'Omeprazole',
      nameAr: 'أوميبرازول',
      strength: '20 mg',
      doseUnit: 'capsule',
    ),
  );
  await schedules.saveGroup(
    medicationId: omeprazole,
    slots: [meal('breakfast', TimingRelation.before)],
    rule: const RecurrenceRule(),
  );
  await inventory.addBatch(BatchInput(
    medicationId: omeprazole,
    quantityScaled: 3 * quantityScale,
    packagingType: 'strip',
    purchaseDate: isoIn(-25),
    expirationDate: isoIn(300),
  ));

  // Panadol: as needed, max 4 a day.
  final panadol = await medications.create(
    mother,
    const MedicationInput(
      nameEn: 'Panadol Extra',
      nameAr: 'بانادول إكسترا',
      doseUnit: 'tablet',
      isPrn: true,
      maximumDailyQuantityScaled: 4 * quantityScale,
    ),
  );
  await inventory.addBatch(BatchInput.fromPackages(
    medicationId: panadol,
    packagesCount: 0,
    unitsPerPackage: 0,
    packagingType: 'strip',
    partialPacks: const [
      PartialPack(type: 'strip', remainingScaled: 9000, capacity: 12),
    ],
    expirationDate: isoIn(500),
  ));

  // Backdate the plans so today's earlier doses exist, then record them.
  final yesterday = DateTime.now().toUtc().subtract(const Duration(days: 1));
  await db.update(db.medicationSchedules).write(
        MedicationSchedulesCompanion(
          createdAt: Value(yesterday),
          updatedAt: Value(yesterday),
        ),
      );
  final appSettings = await settings.load();
  await ref.read(doseGenerationProvider).syncPatient(
        mother,
        graceMinutes: appSettings.missedGraceMinutes,
      );
  final now = DateTime.now().toUtc();
  final doses = await (db.select(db.doseInstances)
        ..where(
          (d) =>
              d.patientId.equals(mother) &
              d.scheduledAt.isSmallerThanValue(now) &
              d.scheduledAt.isBiggerThanValue(
                now.subtract(const Duration(hours: 20)),
              ),
        ))
      .get();
  final doseService = ref.read(doseServiceProvider);
  for (final dose in doses) {
    if (dose.medicationId == omeprazole) continue; // leave one missed
    try {
      await doseService.takeDose(
        doseInstanceId: dose.doseInstanceId,
        actualQuantityScaled: dose.requiredQuantityScaled,
        graceMinutes: appSettings.missedGraceMinutes,
        takenAt: dose.scheduledAt.add(const Duration(minutes: 7)),
      );
    } catch (_) {
      // Keep going; demo data is best effort.
    }
  }
  await doseService.logPrnDose(
    medicationId: panadol,
    actualQuantityScaled: quantityScale,
    takenAt: now.subtract(const Duration(hours: 3)),
  );

  // Health records.
  await ref.read(appointmentRepositoryProvider).save(
        patientId: mother,
        doctorName: 'Dr. Ahmed Mostafa',
        specialty: 'Cardiology',
        scheduledTime: DateTime.now().add(const Duration(days: 3, hours: 2)),
        location: 'Heliopolis Clinic',
      );
  final vitals = ref.read(vitalsRepositoryProvider);
  await vitals.save(
    patientId: mother,
    measurementType: VitalTypes.bloodPressure,
    value1: 128,
    value2: 82,
    unit: 'mmHg',
    measuredAt: DateTime.now().subtract(const Duration(hours: 5)),
    context: VitalContexts.afterMedication,
    relatedMedicationId: concor,
    minutesAfter: 60,
  );
  await vitals.save(
    patientId: mother,
    measurementType: VitalTypes.bloodGlucose,
    value1: 142,
    unit: 'mg/dL',
    measuredAt: DateTime.now().subtract(const Duration(hours: 2)),
    context: VitalContexts.afterMeal,
    relatedMealId: meals['lunch']!.mealId,
    minutesAfter: 120,
  );
  await ref.read(illnessRepositoryProvider).save(
        patientId: mother,
        conditionName: 'Type 2 diabetes',
        diagnosedDate: '2015-03-01',
      );
  await ref.read(illnessRepositoryProvider).save(
        patientId: mother,
        conditionName: 'Hypertension',
        diagnosedDate: '2018-06-15',
      );
  await ref.read(dietaryRuleRepositoryProvider).save(
        patientId: mother,
        foodItemEn: 'Grapefruit',
        foodItemAr: 'الجريب فروت',
        ruleType: DietRuleTypes.avoid,
      );
  ref.read(syncCoordinatorProvider).request();
}
