import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.init();

  // ✅ Verifica la compatibilidad con Firebase Messaging
  bool isSupported = await FirebaseMessaging.instance.isSupported();
  if (isSupported) {
    FirebaseMessaging.instance.getToken().then((token) {
      print("🔑 Token de Firebase en Web: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔔 Notificación recibida: ${message.notification?.title} - ${message.notification?.body}");

      NotificationService.showNotification(
        title: message.notification?.title ?? "Notificación",
        body: message.notification?.body ?? "Has recibido un mensaje",
      );
    });

    // ✅ Registra el Service Worker en Web
   /* if (html.window.navigator.serviceWorker != null) {
      html.window.navigator.serviceWorker!
          .register('/firebase-messaging-sw.js')
          .then((value) => print("✅ Service Worker registrado en Web"))
          .catchError((error) => print("⚠️ Error registrando Service Worker: $error"));
    }*/
  }

  runApp(MyApp());
}

// ✅ Estructura de la App
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prueba Firebase y Notificaciones',
      home: HomePage(),
    );
  }
}

// ✅ Pantalla Principal
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _mensajeFirestore = "Esperando conexión...";

  @override
  void initState() {
    super.initState();
    _probarConexionFirestore();
  }

  // 🔥 Prueba de conexión con Firestore
  Future<void> _probarConexionFirestore() async {
    try {
      // Guarda un mensaje de prueba
      await _firestore.collection('pruebas').doc('conexion').set({
        'mensaje': 'Conexión exitosa con Firestore',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Lee el mensaje de prueba
      DocumentSnapshot doc = await _firestore.collection('pruebas').doc('conexion').get();
      setState(() {
        _mensajeFirestore = doc['mensaje'];
      });

      print("✅ Firestore conectado correctamente.");
    } catch (e) {
      setState(() {
        _mensajeFirestore = "Error conectando a Firestore: $e";
      });
      print("❌ Error conectando a Firestore: $e");
    }
  }

  // 📩 Enviar notificación de prueba
  void _sendTestNotification() {
    NotificationService.showNotification(
      title: "Prueba Manual",
      body: "Si ves esto, la notificación funciona!",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase & Notificaciones")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "🔥 Firestore: $_mensajeFirestore",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sendTestNotification,
            child: Text("🔔 Enviar Notificación"),
          ),
        ],
      ),
    );
  }
}
