import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'reminder_sound.dart';

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

  /// Channels that play the reminder sound the user picked.
  bool get usesReminderSound =>
      this == NotificationChannel.doses || this == NotificationChannel.missed;
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

  /// Sound used for dose reminders and missed-dose alerts.
  ReminderSound get reminderSound;

  /// Removes channels left over from sounds that are no longer selected.
  Future<void> removeStaleSoundChannels();
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
  @override
  ReminderSound get reminderSound => const ReminderSound.systemDefault();
  @override
  Future<void> removeStaleSoundChannels() async {}
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
  ReminderSound Function()? reminderSound,
}) {
  if (!platformSupportsNotifications) return NoopLocalNotifier();
  return FlutterLocalNotifier(
    FlutterLocalNotificationsPlugin(),
    onResponse: onResponse,
    onBackgroundResponse: onBackgroundResponse,
    requestPermissions: requestPermissions,
    reminderSound: reminderSound,
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
    ReminderSound Function()? reminderSound,
  }) : _reminderSound = reminderSound;

  final FlutterLocalNotificationsPlugin _plugin;
  final NotificationResponseHandler? onResponse;
  final DidReceiveBackgroundNotificationResponseCallback? onBackgroundResponse;
  final bool requestPermissions;
  final ReminderSound Function()? _reminderSound;
  bool _ready = false;

  @override
  ReminderSound get reminderSound =>
      _reminderSound?.call() ?? const ReminderSound.systemDefault();

  /// Android channel for [channel] with the current reminder sound.
  String _channelId(NotificationChannel channel) {
    final key = reminderSound.key;
    if (!channel.usesReminderSound || key == 'default') return channel.id;
    return '${channel.id}_$key';
  }

  @override
  Future<void> removeStaleSoundChannels() async {
    if (!_ready) return;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;
    try {
      final current = {
        for (final c in NotificationChannel.values) _channelId(c),
      };
      final soundChannels = [
        for (final c in NotificationChannel.values)
          if (c.usesReminderSound) c.id,
      ];
      for (final channel in await android.getNotificationChannels() ?? []) {
        final id = channel.id;
        final stale = !current.contains(id) &&
            soundChannels
                .any((base) => id == base || id.startsWith('${base}_'));
        if (stale) await android.deleteNotificationChannel(channelId: id);
      }
    } catch (error) {
      debugPrint('Could not clean notification channels: $error');
    }
  }

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
    final sound = channel.usesReminderSound
        ? reminderSound
        : const ReminderSound.systemDefault();
    final silent = sound.kind == ReminderSoundKind.silent;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId(channel),
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
        playSound: channel != NotificationChannel.confirmations && !silent,
        sound: switch (sound.kind) {
          ReminderSoundKind.builtIn =>
            RawResourceAndroidNotificationSound(sound.value),
          ReminderSoundKind.device => UriAndroidNotificationSound(sound.value!),
          _ => null,
        },
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
        presentSound: !silent,
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
