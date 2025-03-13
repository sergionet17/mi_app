import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      print("🔄 Iniciando sesión con Google...");

      // Muestra si Firebase está inicializado
      if (_auth.app == null) {
        print("⚠️ Firebase no está inicializado correctamente.");
        return null;
      }

      // Verifica si Google Play Services están disponibles en Android
      if (!kIsWeb) {
        final googleAvailable = await GoogleSignIn().isSignedIn();
        print("🔍 Google Sign-In está disponible: $googleAvailable");
      }

      // Intenta iniciar sesión con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("⚠️ El usuario canceló el inicio de sesión.");
        return null;
      }
      print("✅ Usuario seleccionado: ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print("❌ Error: Tokens de Google son nulos.");
        return null;
      }

      print("🔑 Tokens recibidos correctamente.");

      // Crea credenciales de Firebase con Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print("🔄 Autenticando con Firebase...");

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      print("✅ Sesión iniciada correctamente con Firebase: ${userCredential.user?.email}");

      return userCredential.user;
    } catch (e) {
      print("❌ Error al iniciar sesión con Google: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    print("🚪 Sesión cerrada correctamente.");
  }

  User? get currentUser => _auth.currentUser;
}
