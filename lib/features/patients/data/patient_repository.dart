import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class PatientRepository {
  PatientRepository(this.database);
  final AppDatabase database;

  Future<List<PatientsData>> list({bool includeArchived = false}) async {
    final query = database.select(database.patients);
    if (!includeArchived) query.where((p) => p.isArchived.equals(false));
    return query.get();
  }

  Future<PatientsData?> get(String id) => (database.select(
        database.patients,
      )..where((p) => p.id.equals(id)))
          .getSingleOrNull();

  Future<void> save({
    required String id,
    required String name,
    String? relation,
    String timezone = 'Africa/Cairo',
  }) async {
    final now = DateTime.now();
    await database.into(database.patients).insertOnConflictUpdate(
          PatientsCompanion.insert(
            id: id,
            name: name,
            relation: Value(relation),
            timezone: Value(timezone),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> archive(String id) async {
    await (database.update(
      database.patients,
    )..where((p) => p.id.equals(id)))
        .write(
      PatientsCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

