import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class OfflineNotificationService {
  OfflineNotificationService(this.plugin);
  final FlutterLocalNotificationsPlugin plugin;

  Future<void> initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await plugin.initialize(settings);
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
      'MedicationsData dose is due',
      tz.TZDateTime.from(when, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'MedicationsData',
          'MedicationsData reminders',
          channelDescription: 'Offline MedicationsData reminders',
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
}
