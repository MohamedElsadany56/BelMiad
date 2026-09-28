import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class NotificationPreferencesRepository {
  NotificationPreferencesRepository(this.database);
  final AppDatabase database;

  Future<bool> isEnabled(String patientId, String type) async {
    final row = await (database.select(database.notificationPreferences)
          ..where(
            (p) =>
                p.patientId.equals(patientId) & p.notificationType.equals(type),
          ))
        .getSingleOrNull();
    return row?.enabled ?? true;
  }

  Future<void> setEnabled({
    required String patientId,
    required String type,
    required bool enabled,
  }) async {
    await database
        .into(database.notificationPreferences)
        .insertOnConflictUpdate(
          NotificationPreferencesCompanion.insert(
            id: '$patientId:$type',
            patientId: patientId,
            notificationType: type,
            enabled: Value(enabled),
          ),
        );
  }
}

