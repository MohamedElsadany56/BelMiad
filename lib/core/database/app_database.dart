import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

export 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Persons,
    Patients,
    CaregiverAssignments,
    PatientIllnesses,
    Medications,
    MedicationInventoryBatches,
    InventoryAdjustments,
    Meals,
    MedicationSchedules,
    DoseInstances,
    DoseInventoryConsumption,
    Appointments,
    VitalsMeasurements,
    DietaryRules,
    Prescriptions,
    Notifications,
    PatientNotificationPreferences,
    AuditEvents,
    TrashItems,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createIndexes();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(medications, medications.storageOnly);
            await m.addColumn(
              medicationInventoryBatches,
              medicationInventoryBatches.subPackagingType,
            );
            await m.addColumn(
              medicationInventoryBatches,
              medicationInventoryBatches.subPackagesPerPackage,
            );
            await m.addColumn(
              medicationInventoryBatches,
              medicationInventoryBatches.looseQuantityScaled,
            );
            await m.addColumn(meals, meals.timeMode);
            await m.addColumn(meals, meals.weekdayTimes);
            await m.addColumn(medicationSchedules, medicationSchedules.groupId);
            await m.addColumn(vitalsMeasurements, vitalsMeasurements.context);
            await m.addColumn(
              vitalsMeasurements,
              vitalsMeasurements.relatedMealId,
            );
            await m.addColumn(
              vitalsMeasurements,
              vitalsMeasurements.relatedMedicationId,
            );
            await m.addColumn(
              vitalsMeasurements,
              vitalsMeasurements.minutesAfter,
            );
          }
          if (from < 3) {
            await m.addColumn(
              medicationInventoryBatches,
              medicationInventoryBatches.partialPacksJson,
            );
            await m.addColumn(doseInstances, doseInstances.loggedAt);
          }
        },
        beforeOpen: (details) async {
          if (!details.wasCreated) await _createIndexes();
        },
      );

  Future<void> _createIndexes() async {
    const statements = [
      'CREATE UNIQUE INDEX IF NOT EXISTS ux_dose_schedule_date '
          'ON dose_instances (schedule_id, local_date) '
          'WHERE schedule_id IS NOT NULL',
      'CREATE INDEX IF NOT EXISTS ix_dose_patient_time '
          'ON dose_instances (patient_id, scheduled_at)',
      'CREATE INDEX IF NOT EXISTS ix_dose_medication '
          'ON dose_instances (medication_id, status)',
      'CREATE INDEX IF NOT EXISTS ix_batch_medication '
          'ON medication_inventory_batches (medication_id)',
      'CREATE INDEX IF NOT EXISTS ix_consumption_dose '
          'ON dose_inventory_consumption (dose_instance_id)',
      'CREATE INDEX IF NOT EXISTS ix_consumption_batch '
          'ON dose_inventory_consumption (inventory_batch_id)',
      'CREATE INDEX IF NOT EXISTS ix_medication_patient '
          'ON medications (patient_id)',
      'CREATE INDEX IF NOT EXISTS ix_schedule_medication '
          'ON medication_schedules (medication_id)',
      'CREATE INDEX IF NOT EXISTS ix_audit_patient '
          'ON audit_events (patient_id, occurred_at)',
    ];
    for (final statement in statements) {
      await customStatement(statement);
    }
  }
}

/// Opens the on-device patient database (SQLite is the source of truth).
AppDatabase openAppDatabase() {
  return AppDatabase(
    driftDatabase(
      name: 'belmiad_health',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
      native: const DriftNativeOptions(shareAcrossIsolates: true),
    ),
  );
}
