import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class MedicationRepository {
  MedicationRepository(this.database);
  final AppDatabase database;

  Future<List<Medication>> listForPatient(
    String patientId, {
    bool includeInactive = false,
  }) async {
    final query = database.select(database.medications)
      ..where((m) => m.patientId.equals(patientId));
    if (!includeInactive) query.where((m) => m.isActive.equals(true));
    return query.get();
  }

  Future<Medication?> get(String id) => (database.select(
        database.medications,
      )..where((m) => m.id.equals(id)))
          .getSingleOrNull();

  Future<void> save({
    required String id,
    required String patientId,
    required String nameEn,
    String? nameAr,
    String? strength,
    String? dosageForm,
    String doseUnit = 'unit',
    bool isPrn = false,
    int? maxDailyQuantityScaled,
  }) async {
    final now = DateTime.now();
    await database.into(database.medications).insertOnConflictUpdate(
          MedicationsCompanion.insert(
            id: id,
            patientId: patientId,
            nameEn: nameEn,
            nameAr: Value(nameAr),
            strength: Value(strength),
            dosageForm: Value(dosageForm),
            doseUnit: Value(doseUnit),
            isPrn: Value(isPrn),
            maxDailyQuantityScaled: Value(maxDailyQuantityScaled),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> archive(String id) async {
    await (database.update(
      database.medications,
    )..where((m) => m.id.equals(id)))
        .write(
      MedicationsCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
