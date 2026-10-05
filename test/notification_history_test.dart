import 'package:belmiad/core/database/app_database.dart';
import 'package:belmiad/features/notifications/data/notification_history.dart';
import 'package:belmiad/features/notifications/data/notification_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_harness.dart';

void main() {
  late TestHarness h;
  late NotificationRepository repo;
  late String patientId;

  setUp(() async {
    h = TestHarness(now: DateTime.utc(2026, 9, 28, 6));
    repo = NotificationRepository(h.db, clock: h.clock);
    await h.createCaregiver();
    patientId = await h.createPatient();
  });

  tearDown(() => h.close());

  Future<void> insert(
    String id, {
    required DateTime at,
    String type = 'dose_reminder',
    String status = 'delivered',
    bool read = false,
  }) =>
      h.db.into(h.db.notifications).insert(
            NotificationsCompanion.insert(
              notificationId: id,
              patientId: patientId,
              notificationType: type,
              dedupKey: 'k-$id',
              scheduledAt: at,
              status: status,
              createdAt: at,
              updatedAt: at,
              isRead: Value(read),
            ),
          );

  Future<Set<String>> ids() async =>
      (await h.db.select(h.db.notifications).get())
          .map((n) => n.notificationId)
          .toSet();

  test('purge removes only rows older than seven days', () async {
    final now = h.now;
    await insert('old', at: now.subtract(const Duration(days: 8)));
    await insert('edge', at: now.subtract(notificationRetention));
    await insert('recent', at: now.subtract(const Duration(days: 6)));
    final removed = await repo.purgeExpired();
    expect(removed, 2);
    expect(await ids(), {'recent'});
  });

  test('purge never touches future scheduled alarms', () async {
    await insert(
      'future',
      at: h.now.add(const Duration(days: 3)),
      status: 'scheduled',
    );
    await insert(
      'future-far',
      at: h.now.add(const Duration(days: 60)),
      status: 'scheduled',
    );
    expect(await repo.purgeExpired(), 0);
    expect(await ids(), {'future', 'future-far'});
  });

  test('mark read, unread, all read and delete one', () async {
    final at = h.now.subtract(const Duration(hours: 1));
    await insert('a', at: at);
    await insert('b', at: at);
    await insert('c', at: at);

    await repo.markRead('a');
    var rows = {
      for (final n in await h.db.select(h.db.notifications).get())
        n.notificationId: n.isRead,
    };
    expect(rows, {'a': true, 'b': false, 'c': false});

    await repo.markUnread('a');
    await repo.markAllRead(patientId);
    rows = {
      for (final n in await h.db.select(h.db.notifications).get())
        n.notificationId: n.isRead,
    };
    expect(rows.values, everyElement(isTrue));

    await repo.delete('b');
    expect(await ids(), {'a', 'c'});
  });

  test('deleteAll(readOnly) keeps unread rows', () async {
    final at = h.now.subtract(const Duration(hours: 1));
    await insert('read', at: at, read: true);
    await insert('unread', at: at);
    await repo.deleteAll(patientId, readOnly: true);
    expect(await ids(), {'unread'});
    await repo.deleteAll(patientId);
    expect(await ids(), isEmpty);
  });
}
