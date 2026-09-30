import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Channels used for offline notifications.
///
/// Android channel settings are fixed once created, so the dose channel uses
/// a new ID to make reminders pop up over the screen (heads-up) like chat
/// messages.
enum NotificationChannel {
  doses('dose_alerts', 'Medication reminders', Importance.max),
  missed('missed_doses', 'Missed doses', Importance.high),
  inventory(
    'inventory_alerts',
    'Stock and expiry alerts',
    Importance.defaultImportance,
  ),
  appointments('appointments', 'Appointment reminders', Importance.high),
  confirmations('confirmations', 'Recorded from notifications', Importance.low);

  const NotificationChannel(this.id, this.label, this.importance);

  final String id;
  final String label;
  final Importance importance;
}

/// A button shown on a notification.
class NotifierAction {
  const NotifierAction(this.id, this.title, {this.opensApp = false});

  final String id;
  final String title;

  /// Brings the app to the foreground instead of running in the background.
  final bool opensApp;
}

/// Called when the user taps a notification or one of its buttons while the
/// app is running.
typedef NotificationResponseHandler = void Function(
  String? actionId,
  String? payload,
);

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
    String? payload,
    List<NotifierAction> actions = const [],
  });
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required NotificationChannel channel,
    String? payload,
    List<NotifierAction> actions = const [],
  });
  Future<void> cancel(int id);
  Future<Set<int>> pendingIds();

  /// Payload of the notification that launched the app, if any.
  Future<String?> launchPayload();
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
    String? payload,
    List<NotifierAction> actions = const [],
  }) async {}
  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required NotificationChannel channel,
    String? payload,
    List<NotifierAction> actions = const [],
  }) async {}
  @override
  Future<void> cancel(int id) async {}
  @override
  Future<Set<int>> pendingIds() async => const {};
  @override
  Future<String?> launchPayload() async => null;
}

bool get platformSupportsNotifications {
  if (kIsWeb) return false;
  return switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.macOS ||
    TargetPlatform.linux =>
      true,
    _ => false,
  };
}

LocalNotifier createPlatformNotifier({
  NotificationResponseHandler? onResponse,
  DidReceiveBackgroundNotificationResponseCallback? onBackgroundResponse,
  bool requestPermissions = true,
}) {
  if (!platformSupportsNotifications) return NoopLocalNotifier();
  return FlutterLocalNotifier(
    FlutterLocalNotificationsPlugin(),
    onResponse: onResponse,
    onBackgroundResponse: onBackgroundResponse,
    requestPermissions: requestPermissions,
  );
}

/// iOS/macOS category carrying the dose buttons.
const doseActionCategory = 'dose_actions';

class FlutterLocalNotifier implements LocalNotifier {
  FlutterLocalNotifier(
    this._plugin, {
    this.onResponse,
    this.onBackgroundResponse,
    this.requestPermissions = true,
  });

  final FlutterLocalNotificationsPlugin _plugin;
  final NotificationResponseHandler? onResponse;
  final DidReceiveBackgroundNotificationResponseCallback? onBackgroundResponse;
  final bool requestPermissions;
  bool _ready = false;

  static const _brand = Color(0xFF0064F6);

  @override
  Future<void> initialize() async {
    if (_ready) return;
    final darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: [
        DarwinNotificationCategory(
          doseActionCategory,
          actions: [
            DarwinNotificationAction.plain('take', '✓ Take'),
            DarwinNotificationAction.plain('snooze', 'Snooze 10 min'),
          ],
        ),
      ],
    );
    final settings = InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: darwin,
      macOS: darwin,
      linux: const LinuxInitializationSettings(defaultActionName: 'Open'),
    );
    try {
      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (response) =>
            onResponse?.call(response.actionId, response.payload),
        onDidReceiveBackgroundNotificationResponse: onBackgroundResponse,
      );
      if (requestPermissions) {
        final android = _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        await android?.requestNotificationsPermission();
        await android?.requestExactAlarmsPermission();
        await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      }
      _ready = true;
    } catch (error) {
      debugPrint('Notifications unavailable: $error');
    }
  }

  NotificationDetails _details(
    NotificationChannel channel,
    String body,
    List<NotifierAction> actions,
  ) {
    final urgent = channel == NotificationChannel.doses ||
        channel == NotificationChannel.missed;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.label,
        importance: channel.importance,
        priority: switch (channel) {
          NotificationChannel.doses => Priority.max,
          NotificationChannel.confirmations => Priority.low,
          NotificationChannel.inventory => Priority.defaultPriority,
          _ => Priority.high,
        },
        category: channel == NotificationChannel.doses
            ? AndroidNotificationCategory.reminder
            : null,
        visibility: NotificationVisibility.public,
        color: _brand,
        ticker: body,
        styleInformation: BigTextStyleInformation(body),
        autoCancel: true,
        playSound: channel != NotificationChannel.confirmations,
        enableVibration: urgent,
        actions: [
          for (final action in actions)
            AndroidNotificationAction(
              action.id,
              action.title,
              showsUserInterface: action.opensApp,
              titleColor: _brand,
            ),
        ],
      ),
      iOS: DarwinNotificationDetails(
        categoryIdentifier: actions.isEmpty ? null : doseActionCategory,
        interruptionLevel:
            urgent ? InterruptionLevel.timeSensitive : InterruptionLevel.active,
      ),
      macOS: DarwinNotificationDetails(
        categoryIdentifier: actions.isEmpty ? null : doseActionCategory,
      ),
    );
  }

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
    if (!_ready) return;
    Future<void> attempt(AndroidScheduleMode mode) => _plugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: tz.TZDateTime.from(at.toUtc(), tz.UTC),
          notificationDetails: _details(channel, body, actions),
          androidScheduleMode: mode,
          payload: payload,
        );
    try {
      await attempt(AndroidScheduleMode.exactAllowWhileIdle);
    } catch (_) {
      // Exact alarms may be denied; fall back to inexact scheduling.
      try {
        await attempt(AndroidScheduleMode.inexactAllowWhileIdle);
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
    String? payload,
    List<NotifierAction> actions = const [],
  }) async {
    if (!_ready) return;
    try {
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _details(channel, body, actions),
        payload: payload,
      );
    } catch (error) {
      debugPrint('Failed to show notification: $error');
    }
  }

  @override
  Future<void> cancel(int id) async {
    if (!_ready) return;
    try {
      await _plugin.cancel(id: id);
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

  @override
  Future<String?> launchPayload() async {
    if (!_ready) return null;
    try {
      final details = await _plugin.getNotificationAppLaunchDetails();
      if (details?.didNotificationLaunchApp ?? false) {
        return details!.notificationResponse?.payload ?? '';
      }
    } catch (_) {}
    return null;
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
