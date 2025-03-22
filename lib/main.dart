import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'notification_service.dart';

import 'home_page.dart';
import 'email_login_screen.dart';
import 'dashboard_screen.dart';
import 'email_register_screen.dart'; // ✅ Asegúrate de importar esta

import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.init();

  bool isSupported = await FirebaseMessaging.instance.isSupported();
  if (isSupported) {
    FirebaseMessaging.instance.getToken().then((token) {
      print("🔑 Token de Firebase: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔔 Notificación recibida: ${message.notification?.title} - ${message.notification?.body}");
      NotificationService.showNotification(
        title: message.notification?.title ?? "Notificación",
        body: message.notification?.body ?? "Has recibido un mensaje",
      );
    });
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi App Firebase',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => EmailLoginScreen(),
        '/register': (context) => EmailRegisterScreen(), // ✅ Ruta correcta
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}
