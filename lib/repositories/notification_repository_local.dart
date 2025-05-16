import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_flutter/repositories/notification_repository.dart';

class NotificationRepositoryLocal implements NotificationRepository {
  static final NotificationRepositoryLocal _instance =
      NotificationRepositoryLocal._internal();

  NotificationRepositoryLocal._internal();

  factory NotificationRepositoryLocal() {
    return _instance;
  }

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _requestAndroidPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestExactAlarmsPermission();
  }

  @override
  Future<void> initNotifications() async {
    _requestAndroidPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Future<void> showNotification(
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

  @override
  Future<void> scheduleNotification(
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

  @override
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
