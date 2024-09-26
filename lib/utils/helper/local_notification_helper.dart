import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationHelper {
  LocalNotificationHelper._();
  static final LocalNotificationHelper localNotificationHelper =
      LocalNotificationHelper._();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications() async {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("mipmap/ic_launcher");
    DarwinInitializationSettings IOSInitializationSettings =
        DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: IOSInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showSimpleNotification(
      {required String id, required String name}) async {
    await initLocalNotifications();

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      id,
      name,
      priority: Priority.max,
      importance: Importance.max,
    );
    DarwinNotificationDetails IOSNotificationDetails =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: IOSNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      1,
      id,
      name,
      notificationDetails,
    );
  }

  Future<void> showBigPictureNotification() async {
    await initLocalNotifications();

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "SN",
      "Simple Notification",
      priority: Priority.max,
      importance: Importance.max,
      styleInformation: BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
      ),
    );
    DarwinNotificationDetails IOSNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: IOSNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      1,
      "Simple Title",
      "Dummy dis",
      notificationDetails,
    );
  }

  Future<void> showMediastyleNotification() async {
    await initLocalNotifications();

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "SN",
      "Simple Notification",
      priority: Priority.max,
      importance: Importance.max,
      styleInformation: BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
      ),
    );
    DarwinNotificationDetails IOSNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: IOSNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      1,
      "Simple Title",
      "Dummy dis",
      notificationDetails,
    );
  }
}
