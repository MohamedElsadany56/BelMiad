import 'package:belmiad/core/notifications/local_notifier.dart';

class RecordedNotification {
  const RecordedNotification({
    required this.title,
    required this.body,
    required this.channel,
    this.at,
    this.payload,
    this.actions = const [],
  });

  final String title;
  final String body;
  final NotificationChannel channel;
  final DateTime? at;
  final String? payload;
  final List<NotifierAction> actions;
}

/// In-memory notifier recording what would be shown on the device.
class FakeNotifier implements LocalNotifier {
  final scheduled = <int, DateTime>{};
  final shown = <int>[];
  final cancelled = <int>[];
  final details = <int, RecordedNotification>{};

  @override
  Future<void> initialize() async {}

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime at,
    required NotificationChannel channel,
    String? payload,
    List<NotifierAction> actions = const [],
  }) async {
    scheduled[id] = at;
    details[id] = RecordedNotification(
      title: title,
      body: body,
      channel: channel,
      at: at,
      payload: payload,
      actions: actions,
    );
  }

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required NotificationChannel channel,
    String? payload,
    List<NotifierAction> actions = const [],
  }) async {
    shown.add(id);
    details[id] = RecordedNotification(
      title: title,
      body: body,
      channel: channel,
      payload: payload,
      actions: actions,
    );
  }

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
    scheduled.remove(id);
  }

  @override
  Future<Set<int>> pendingIds() async => scheduled.keys.toSet();

  @override
  Future<String?> launchPayload() async => null;
}
