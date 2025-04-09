import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

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
        AndroidInitializationSettings('notification_icon');

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

  static Future<void> scheduleNotification(
      {int id = 0,
      required String title,
      required String body,
      String payload = '',
      required DateTime datetime}) async {
    const androidNotificationDetails = AndroidNotificationDetails(
        'todos', 'todos',
        channelDescription: 'Tarefas',
        importance: Importance.max,
        priority: Priority.high);

    const notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(datetime, tz.local), notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
