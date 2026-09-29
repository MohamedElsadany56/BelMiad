import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class OfflineNotificationService {
  OfflineNotificationService(this.plugin);
  final FlutterLocalNotificationsPlugin plugin;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    if (kIsWeb) {
      _initialized = true;
      return;
    }
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await plugin.initialize(settings);
    await plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
    await plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);
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

  Future<void> scheduleMissedDose({
    required int id,
    required String medicineName,
    required DateTime when,
  }) async {
    if (kIsWeb) return;
    await plugin.zonedSchedule(
      id,
      'Missed dose: $medicineName',
      'This medication dose has not been marked as taken.',
      tz.TZDateTime.from(when, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'missed_medication_reminders',
          'Missed medication reminders',
          channelDescription: 'Offline missed-dose reminders',
          importance: Importance.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleInventoryAlert({
    required int id,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    if (kIsWeb) return;
    await plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(when, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'inventory_alerts',
          'Inventory alerts',
          channelDescription: 'Offline stock and expiry alerts',
          importance: Importance.defaultImportance,
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

