import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_app/widgets/cart_icon_button.dart';
import 'auth_service.dart';
import 'store_products_screen.dart';
import 'comercio_card.dart';


class DashboardScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  Future<List<Map<String, dynamic>>> fetchComercios({bool destacados = false}) async {
    final snapshot = await FirebaseFirestore.instance.collection('stores').get();
    final comercios = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).where((data) {
      if (destacados) return data['featured'] == '1';
      return true;
    }).toList();
    return comercios;
  }

  @override
  Widget build(BuildContext context) {
    final userName = FirebaseAuth.instance.currentUser?.displayName ?? 'Usuario';

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8FD),
      appBar: AppBar(
        title: const Text("PitalitoComercio"),
        actions: [
          const CartIconButton(), // ✅ Carrito visible
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/home');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hola, $userName 👋", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Comercios destacados", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildComerciosDestacados(context),
            const SizedBox(height: 20),
            const Text("Todos los comercios", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildTodosLosComercios(context),
          ],
        ),
      ),
    );
  }

  Widget _buildComerciosDestacados(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchComercios(destacados: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
        final comercios = snapshot.data ?? [];
        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: comercios.length,
            itemBuilder: (context, index) {
              final comercio = comercios[index];
              return ComercioCard(comercio: comercio, isHorizontal: true);
            },
          ),
        );
      },
    );
  }

  Widget _buildTodosLosComercios(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchComercios(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
        final comercios = snapshot.data ?? [];
        return Column(
          children: comercios.map((comercio) => ComercioCard(comercio: comercio)).toList(),
        );
      },
    );
  }
}
