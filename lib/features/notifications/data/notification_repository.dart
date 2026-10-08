import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/time/clock.dart';
import '../../../core/utilities/ids.dart';
import '../application/notification_engine.dart';
import '../domain/notification_types.dart';
import 'notification_history.dart';

/// In-app notification centre and per-patient preferences.
class NotificationRepository {
  NotificationRepository(this._db, {Clock clock = systemClock})
      : _clock = clock;

  final AppDatabase _db;
  final Clock _clock;

  /// Notifications that are due (delivered, or scheduled in the past).
  Stream<List<AppNotification>> watchCentre(String patientId) {
    final now = _clock();
    return (_db.select(_db.notifications)
          ..where(
            (n) =>
                n.patientId.equals(patientId) &
                n.status.isIn([
                  NotificationStatus.delivered,
                  NotificationStatus.resolved,
                  NotificationStatus.scheduled,
                ]) &
                n.scheduledAt.isSmallerOrEqualValue(now),
          )
          ..orderBy([(n) => OrderingTerm.desc(n.scheduledAt)])
          ..limit(200))
        .watch();
  }

  Stream<int> watchUnreadCount(String patientId) {
    final now = _clock();
    final count = _db.notifications.notificationId.count();
    final query = _db.selectOnly(_db.notifications)
      ..addColumns([count])
      ..where(
        _db.notifications.patientId.equals(patientId) &
            _db.notifications.isRead.equals(false) &
            _db.notifications.status.isIn([
              NotificationStatus.delivered,
              NotificationStatus.scheduled,
            ]) &
            _db.notifications.scheduledAt.isSmallerOrEqualValue(now),
      );
    return query.watchSingle().map((r) => r.read(count) ?? 0);
  }

  Future<void> markRead(String notificationId) => (_db.update(_db.notifications)
        ..where((n) => n.notificationId.equals(notificationId)))
      .write(const NotificationsCompanion(isRead: Value(true)));

  Future<void> markUnread(String notificationId) =>
      (_db.update(_db.notifications)
            ..where((n) => n.notificationId.equals(notificationId)))
          .write(const NotificationsCompanion(isRead: Value(false)));

  /// Removes one notification from the centre.
  Future<void> delete(String notificationId) async {
    final rows = await (_db.select(_db.notifications)
          ..where((n) => n.notificationId.equals(notificationId)))
        .get();
    await removeNotifications(_db, rows, _clock());
  }

  /// Removes the patient's notifications from the centre; [readOnly] keeps
  /// the unread ones.
  Future<void> deleteAll(String patientId, {bool readOnly = false}) async {
    final now = _clock();
    final rows = await (_db.select(_db.notifications)
          ..where(
            (n) =>
                n.patientId.equals(patientId) &
                n.status.isIn([
                  NotificationStatus.delivered,
                  NotificationStatus.resolved,
                  NotificationStatus.scheduled,
                ]) &
                n.scheduledAt.isSmallerOrEqualValue(now) &
                (readOnly ? n.isRead.equals(true) : const Constant(true)),
          ))
        .get();
    await removeNotifications(_db, rows, now);
  }

  /// Deletes history older than seven days (also runs on every sync).
  Future<int> purgeExpired() => purgeExpiredNotifications(_db, _clock());

  Future<void> markAllRead(String patientId) => (_db.update(_db.notifications)
        ..where(
          (n) => n.patientId.equals(patientId) & n.isRead.equals(false),
        ))
      .write(const NotificationsCompanion(isRead: Value(true)));

  Stream<Map<String, bool>> watchPreferences(String patientId) =>
      (_db.select(_db.patientNotificationPreferences)
            ..where((p) => p.patientId.equals(patientId)))
          .watch()
          .map((rows) => {
                for (final type in NotificationTypes.all) type: true,
                for (final r in rows) r.notificationType: r.enabled,
              });

  Future<void> setPreference(
    String patientId,
    String type,
    bool enabled,
  ) async {
    final now = _clock();
    final existing = await (_db.select(_db.patientNotificationPreferences)
          ..where(
            (p) =>
                p.patientId.equals(patientId) & p.notificationType.equals(type),
          ))
        .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.patientNotificationPreferences).insert(
            PatientNotificationPreferencesCompanion.insert(
              preferenceId: newId(),
              patientId: patientId,
              notificationType: type,
              enabled: enabled,
              createdAt: now,
              updatedAt: now,
            ),
          );
    } else {
      await (_db.update(_db.patientNotificationPreferences)
            ..where((p) => p.preferenceId.equals(existing.preferenceId)))
          .write(PatientNotificationPreferencesCompanion(
        enabled: Value(enabled),
        updatedAt: Value(now),
      ));
    }
  }
}
