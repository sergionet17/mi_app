import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_service.dart';

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

  Future<void> _signInWithGoogle() async {
    print("🔄 Iniciando sesión con Google...");
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print("✅ Sesión iniciada con Google: ${userCredential.user?.email}");

      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      print("❌ Error al iniciar sesión con Google: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase & Notificaciones")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "🔥 Firestore: $_mensajeFirestore",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: Text("📧 Iniciar sesión con correo"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: Text("📝 Registrarse con correo"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: Text("🔐 Iniciar sesión con Google"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _sendTestNotification,
              child: Text("🔔 Enviar notificación"),
            ),
          ],
        ),
      ),
    );
  }
}
