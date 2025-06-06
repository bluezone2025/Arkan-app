import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );
    _notificationsPlugin.initialize(
      initializationSettings,

    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

       NotificationDetails notificationDetails =  const NotificationDetails(
        android: AndroidNotificationDetails(
          "pushnotificationapp",
          "pushnotificationappchannel",
         // "pushnotificationappchannel",
          importance: Importance.max,
          priority: Priority.high,
        ) ,
      );
      await _notificationsPlugin.show(
        id,
        '${message.notification?.title}',
        '${message.notification?.body}',
        notificationDetails,
      );
    } on Exception catch (e) {

    }
  }
}
