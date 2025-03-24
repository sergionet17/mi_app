import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'notification_service.dart';

import 'screens/home_page.dart';
import 'email_login_screen.dart';
import 'email_register_screen.dart';
import 'dashboard_screen.dart';
import 'marketplace_screen.dart';
import 'splash_screen.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart'; // 👈 Importa tu provider

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.green,
  scaffoldBackgroundColor: Color(0xFFFDF8FD),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.green),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
    prefixIconColor: Colors.grey[600],
    labelStyle: TextStyle(color: Colors.grey[800]),
  ),
);

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()), // 👈 Aquí el provider del carrito
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PitalitoComercio',
      theme: appTheme,
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => EmailLoginScreen(),
        '/register': (context) => EmailRegisterScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/marketplace': (context) => MarketplaceScreen(),
      },
    );
  }
}
