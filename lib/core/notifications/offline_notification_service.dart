import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class OfflineNotificationService {
  OfflineNotificationService(this.plugin);
  final FlutterLocalNotificationsPlugin plugin;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await plugin.initialize(settings);
    _initialized = true;
  }

  Future<void> scheduleDose({
    required int id,
    required String patientName,
    required String medicineName,
    required DateTime when,
  }) async {
    await plugin.zonedSchedule(
      id,
      '$medicineName for $patientName',
      'Medication dose is due',
      tz.TZDateTime.from(when, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_reminders',
          'Medication reminders',
          channelDescription: 'Offline medication reminders',
          importance: Importance.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancel(int id) => plugin.cancel(id);

  Future<void> cancelAll() => plugin.cancelAll();
}

