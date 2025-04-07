import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationRepository {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void _requestAndroidPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestExactAlarmsPermission();
  }

  static Future<void> initNotifications() async {
    _requestAndroidPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(
      {int id = 0,
      required String title,
      required String body,
      String payload = ''}) async {
    const androidNotificationDetails = AndroidNotificationDetails(
        'todos', 'todos',
        channelDescription: 'Tarefas',
        importance: Importance.max,
        priority: Priority.high);

    const notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin
        .show(id, title, body, notificationDetails, payload: payload);
  }
}
