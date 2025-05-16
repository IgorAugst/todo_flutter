abstract interface class NotificationRepository {
  Future<void> initNotifications();

  Future<void> showNotification(
      {int id, required String title, required String body, String payload});

  Future<void> scheduleNotification(
      {int id,
      required String title,
      required String body,
      String payload,
      required DateTime datetime});

  Future<void> cancelNotification(int id);
}
