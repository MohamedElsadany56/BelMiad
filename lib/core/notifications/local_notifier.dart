import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Channels used for offline notifications.
enum NotificationChannel {
  doses('dose_reminders', 'Medication reminders', Importance.max),
  missed('missed_doses', 'Missed doses', Importance.high),
  inventory('inventory_alerts', 'Stock and expiry alerts',
      Importance.defaultImportance),
  appointments('appointments', 'Appointment reminders', Importance.high);

  const NotificationChannel(this.id, this.label, this.importance);

  final String id;
  final String label;
  final Importance importance;
}

/// Thin platform abstraction so the engine can be tested and so platforms
/// without local notification support degrade to the in-app centre.
abstract class LocalNotifier {
  Future<void> initialize();
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime at,
    required NotificationChannel channel,
  });
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required NotificationChannel channel,
  });
  Future<void> cancel(int id);
  Future<Set<int>> pendingIds();
}

class NoopLocalNotifier implements LocalNotifier {
  @override
  Future<void> initialize() async {}
  @override
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime at,
    required NotificationChannel channel,
  }) async {}
  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required NotificationChannel channel,
  }) async {}
  @override
  Future<void> cancel(int id) async {}
  @override
  Future<Set<int>> pendingIds() async => const {};
}

LocalNotifier createPlatformNotifier() {
  if (kIsWeb) return NoopLocalNotifier();
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
    case TargetPlatform.linux:
      return FlutterLocalNotifier(FlutterLocalNotificationsPlugin());
    default:
      return NoopLocalNotifier();
  }
}

class FlutterLocalNotifier implements LocalNotifier {
  FlutterLocalNotifier(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;

  @override
  Future<void> initialize() async {
    if (_ready) return;
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      macOS: DarwinInitializationSettings(),
      linux: LinuxInitializationSettings(defaultActionName: 'Open'),
    );
    try {
      await _plugin.initialize(settings);
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestNotificationsPermission();
      await android?.requestExactAlarmsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      _ready = true;
    } catch (error) {
      debugPrint('Notifications unavailable: $error');
    }
  }

  NotificationDetails _details(NotificationChannel channel) =>
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.label,
          importance: channel.importance,
          priority: channel == NotificationChannel.inventory
              ? Priority.defaultPriority
              : Priority.high,
          category: channel == NotificationChannel.doses
              ? AndroidNotificationCategory.reminder
              : null,
        ),
        iOS: const DarwinNotificationDetails(),
        macOS: const DarwinNotificationDetails(),
      );

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime at,
    required NotificationChannel channel,
  }) async {
    if (!_ready) return;
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(at.toUtc(), tz.UTC),
        _details(channel),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (_) {
      // Exact alarms may be denied; fall back to inexact scheduling.
      try {
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(at.toUtc(), tz.UTC),
          _details(channel),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (error) {
        debugPrint('Failed to schedule notification: $error');
      }
    }
  }

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required NotificationChannel channel,
  }) async {
    if (!_ready) return;
    try {
      await _plugin.show(id, title, body, _details(channel));
    } catch (error) {
      debugPrint('Failed to show notification: $error');
    }
  }

  @override
  Future<void> cancel(int id) async {
    if (!_ready) return;
    try {
      await _plugin.cancel(id);
    } catch (_) {}
  }

  @override
  Future<Set<int>> pendingIds() async {
    if (!_ready) return const {};
    try {
      final pending = await _plugin.pendingNotificationRequests();
      return pending.map((p) => p.id).toSet();
    } catch (_) {
      return const {};
    }
  }
}

/// Stable 31-bit platform ID derived from a dedup key (FNV-1a).
int notificationIdFor(String dedupKey) {
  var hash = 0x811c9dc5;
  for (final unit in dedupKey.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  return hash & 0x7FFFFFFF;
}
