import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'home_page.dart';
import 'main.dart';

class DashboardScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()), // Volver a la pantalla de inicio
              );
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          "Bienvenido, ${_authService.currentUser?.displayName ?? 'Usuario'}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
