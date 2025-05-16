import 'package:todo_flutter/repositories/notification_repository.dart';

class NotificationRepositoryWeb implements NotificationRepository {
  @override
  Future<void> cancelNotification(int id) async {}

  @override
  Future<void> initNotifications() async {}

  @override
  Future<void> scheduleNotification(
      {int id = 0,
      required String title,
      required String body,
      String payload = '',
      required DateTime datetime}) async {}

  @override
  Future<void> showNotification(
      {int id = 0,
      required String title,
      required String body,
      String payload = ''}) async {}
}
