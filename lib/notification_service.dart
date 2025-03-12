import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'dart:html' as html;

late BuildContext globalContext;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> showNotification({required String title, required String body}) async {
   /* if (html.window.navigator.serviceWorker != null) {
      if (html.Notification.supported) {
        html.Notification.requestPermission().then((permission) {
          if (permission == "granted") {
            html.Notification(title, body: body);
          }
        });
      }
      return;
    } */

    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "mi_canal_id",
        "Mi Canal de Notificaciones",
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      0,
      title,
      body,
      details,
    );
  }
}
