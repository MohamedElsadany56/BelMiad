import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../doses/domain/dose_state_machine.dart';
import '../../inventory/data/inventory_service.dart';

class DoseRepository {
  DoseRepository(this.database);
  final AppDatabase database;

  Future<List<DoseInstance>> forDate(String patientId, DateTime date) =>
      (database.select(database.doseInstances)
            ..where(
              (d) =>
                  d.patientId.equals(patientId) &
                  d.scheduledAt.isBetweenValues(
                    DateTime(date.year, date.month, date.day),
                    DateTime(date.year, date.month, date.day, 23, 59, 59),
                  ),
            ))
          .get();

  Future<void> markTaken(
    String doseId, {
    required int actualQuantityScaled,
  }) async {
    final dose = await (database.select(
      database.doseInstances,
    )..where((d) => d.id.equals(doseId)))
        .getSingle();
    final current = DoseStatus.values.byName(dose.status.toLowerCase());
    DoseStateMachine.transition(current, DoseStatus.taken);
    await InventoryService(database).consumeForMedication(
      medicationId: dose.medicationId,
      quantityScaled: actualQuantityScaled,
    );
    await database.transaction(() async {
      await (database.update(
        database.doseInstances,
      )..where((d) => d.id.equals(doseId)))
          .write(
        DoseInstancesCompanion(
          actualQuantityScaled: Value(actualQuantityScaled),
          status: const Value('TAKEN'),
          takenAt: Value(DateTime.now()),
        ),
      );
    });
  }

  Future<void> skip(String doseId) async {
    final dose = await (database.select(
      database.doseInstances,
    )..where((d) => d.id.equals(doseId)))
        .getSingle();
    DoseStateMachine.transition(
      DoseStatus.values.byName(dose.status.toLowerCase()),
      DoseStatus.skipped,
    );
    await (database.update(database.doseInstances)
          ..where((d) => d.id.equals(doseId)))
        .write(const DoseInstancesCompanion(status: Value('SKIPPED')));
  }
}

