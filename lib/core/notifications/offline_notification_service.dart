import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class OfflineNotificationService {
  OfflineNotificationService(this.plugin);
  final FlutterLocalNotificationsPlugin plugin;

  Future<void> initialize() async {
    const settings = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: DarwinInitializationSettings());
    await plugin.initialize(settings);
  }

  Future<void> scheduleDose({required int id, required String patientName, required String medicineName, required DateTime when}) async {
    await plugin.zonedSchedule(id, '$medicineName for $patientName', 'Medication dose is due', when as dynamic, const NotificationDetails(android: AndroidNotificationDetails('medication', 'Medication reminders', channelDescription: 'Offline medication reminders', importance: Importance.high), iOS: DarwinNotificationDetails()), androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancel(int id) => plugin.cancel(id);
}
