import 'package:belmiad/core/database/app_database.dart';
import 'package:belmiad/core/session/session_context.dart';
import 'package:belmiad/core/settings/settings_repository.dart';
import 'package:belmiad/features/audit/data/audit_log.dart';
import 'package:belmiad/features/caregivers/data/caregiver_repository.dart';
import 'package:belmiad/features/doses/application/dose_service.dart';
import 'package:belmiad/features/doses/data/dose_repository.dart';
import 'package:belmiad/features/inventory/application/inventory_service.dart';
import 'package:belmiad/features/inventory/application/stock_forecast_service.dart';
import 'package:belmiad/features/inventory/data/inventory_repository.dart';
import 'package:belmiad/features/meals/data/meal_repository.dart';
import 'package:belmiad/features/medications/data/medication_repository.dart';
import 'package:belmiad/features/patients/data/patient_repository.dart';
import 'package:belmiad/features/schedules/application/dose_generation_service.dart';
import 'package:belmiad/features/schedules/application/schedule_plan_loader.dart';
import 'package:belmiad/features/schedules/data/schedule_repository.dart';
import 'package:belmiad/features/trash/data/trash_repository.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:timezone/data/latest.dart' as tzdata;

/// Wires every service against an in-memory database and a controllable
/// clock.
class TestHarness {
  TestHarness({DateTime? now}) : now = now ?? DateTime.utc(2026, 9, 28, 6) {
    tzdata.initializeTimeZones();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    session = SessionContext();
    audit = AuditLog(db, session, clock: clock);
    settings = SettingsRepository(db);
    patients = PatientRepository(db, audit, clock: clock);
    caregivers = CaregiverRepository(db, settings, audit, clock: clock);
    medications = MedicationRepository(db, audit, clock: clock);
    meals = MealRepository(db, audit, clock: clock);
    schedules = ScheduleRepository(db, audit, clock: clock);
    loader = SchedulePlanLoader(db);
    generation = DoseGenerationService(db, loader, audit, clock: clock);
    inventory = InventoryRepository(db, audit, session, clock: clock);
    inventoryService = InventoryService(db, inventory, clock: clock);
    doses = DoseService(
      db,
      inventory,
      inventoryService,
      audit,
      session,
      clock: clock,
    );
    doseRepository = DoseRepository(db);
    forecast = StockForecastService(db, loader, settings, clock: clock);
    trash = TrashRepository(db, audit, clock: clock);
  }

  DateTime now;
  DateTime clock() => now;

  late final AppDatabase db;
  late final SessionContext session;
  late final AuditLog audit;
  late final SettingsRepository settings;
  late final PatientRepository patients;
  late final CaregiverRepository caregivers;
  late final MedicationRepository medications;
  late final MealRepository meals;
  late final ScheduleRepository schedules;
  late final SchedulePlanLoader loader;
  late final DoseGenerationService generation;
  late final InventoryRepository inventory;
  late final InventoryService inventoryService;
  late final DoseService doses;
  late final DoseRepository doseRepository;
  late final StockForecastService forecast;
  late final TrashRepository trash;

  Future<String> createCaregiver([String name = 'Nurse Sara']) async {
    final id = await caregivers.createPerson(fullName: name);
    await caregivers.setDeviceCaregiver(id);
    session.actorPersonId = id;
    return id;
  }

  Future<String> createPatient([String name = 'Mother']) => patients.create(
        PatientInput(fullName: name, timezone: 'Africa/Cairo'),
        caregiverPersonId: session.actorPersonId,
      );

  Future<String> createMedication(
    String patientId, {
    String name = 'Panadol',
    bool prn = false,
    int? maximumDailyScaled,
  }) =>
      medications.create(
        patientId,
        MedicationInput(
          nameEn: name,
          doseUnit: 'tablet',
          strength: '500 mg',
          isPrn: prn,
          maximumDailyQuantityScaled: maximumDailyScaled,
        ),
      );

  Future<List<DoseInstance>> allDoses(String patientId) =>
      (db.select(db.doseInstances)
            ..where((d) => d.patientId.equals(patientId))
            ..orderBy([(d) => OrderingTerm.asc(d.scheduledAt)]))
          .get();

  Future<DoseInstance> dose(String id) =>
      (db.select(db.doseInstances)..where((d) => d.doseInstanceId.equals(id)))
          .getSingle();

  Future<InventoryBatch> batch(String id) =>
      (db.select(db.medicationInventoryBatches)
            ..where((b) => b.inventoryBatchId.equals(id)))
          .getSingle();

  Future<void> close() => db.close();
}
