import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import 'dashboard_screen.dart'; // Importar la nueva pantalla

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.init();

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
  }

  runApp(MyApp());
}

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  String _mensajeFirestore = "Esperando conexión...";
  User? _user;

  @override
  void initState() {
    super.initState();
    _probarConexionFirestore();
    _user = _authService.currentUser;
  }

  Future<void> _probarConexionFirestore() async {
    try {
      await _firestore.collection('pruebas').doc('conexion').set({
        'mensaje': 'Conexión exitosa con Firestore',
        'timestamp': FieldValue.serverTimestamp(),
      });

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

  void _sendTestNotification() {
    NotificationService.showNotification(
      title: "Prueba Manual",
      body: "Si ves esto, la notificación funciona!",
    );
  }

  Future<void> _signIn() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      setState(() {
        _user = user;
      });
      print("✅ Usuario autenticado: ${user.displayName}");

      // 🚀 Redirigir a DashboardScreen después de iniciar sesión
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      });
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    setState(() {
      _user = null;
    });
    print("✅ Sesión cerrada");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase, Notificaciones y Auth")),
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
          SizedBox(height: 20),
          _user == null
              ? ElevatedButton(
            onPressed: _signIn,
            child: Text("🔑 Iniciar sesión con Google"),
          )
              : Column(
            children: [
              Text("👤 Usuario: ${_user!.displayName}"),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _signOut,
                child: Text("🚪 Cerrar sesión"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
