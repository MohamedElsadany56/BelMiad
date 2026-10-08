import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/notification_types.dart';

/// Notification records older than this are removed automatically.
const notificationRetention = Duration(days: 7);

/// Rows whose scheduled time is at or before this instant are expired.
DateTime notificationRetentionCutoff(DateTime now) =>
    now.toUtc().subtract(notificationRetention);

/// Status of a stock/expiry notification the user removed from the centre.
/// The row is kept (hidden) so the same ongoing condition does not alert
/// again immediately; it is purged with the rest of the history.
const notificationDismissed = 'dismissed';

/// Notification types that are raised once per ongoing condition. Removing
/// them hides them instead of deleting, otherwise the next sync would raise
/// the same alert again.
const _conditionTypes = {
  NotificationTypes.lowStock,
  NotificationTypes.emptyStock,
  NotificationTypes.expiration,
};

/// Deletes notification history older than [notificationRetention].
///
/// Only rows whose scheduled time is more than seven days in the past are
/// removed, so active and future scheduled notifications are never touched.
/// Returns the number of deleted rows.
Future<int> purgeExpiredNotifications(AppDatabase db, DateTime now) {
  final cutoff = notificationRetentionCutoff(now);
  return (db.delete(db.notifications)
        ..where((n) => n.scheduledAt.isSmallerOrEqualValue(cutoff)))
      .go();
}

/// Removes notifications from the centre on the user's request.
Future<void> removeNotifications(
  AppDatabase db,
  Iterable<AppNotification> rows,
  DateTime now,
) async {
  final hide = <String>[];
  final delete = <String>[];
  for (final row in rows) {
    (_conditionTypes.contains(row.notificationType) ? hide : delete)
        .add(row.notificationId);
  }
  await db.transaction(() async {
    if (hide.isNotEmpty) {
      await (db.update(db.notifications)
            ..where((n) => n.notificationId.isIn(hide)))
          .write(NotificationsCompanion(
        status: const Value(notificationDismissed),
        isRead: const Value(true),
        updatedAt: Value(now),
      ));
    }
    if (delete.isNotEmpty) {
      await (db.delete(db.notifications)
            ..where((n) => n.notificationId.isIn(delete)))
          .go();
    }
  });
}
