import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
  FlutterLocalNotificationsPlugin();

  static Future init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: android,
    );

    await notifications.initialize(settings);
  }

  static Future showWarning(String deviceName) async {
    await notifications.show(
      0,
      "⚠ AI Alert",
      "$deviceName has abnormal power consumption",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "ai_channel",
          "AI Alerts",
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}