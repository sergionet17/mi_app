import 'package:flutter/material.dart';

class MarketplaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comercios Disponibles'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCommerceCard("Tienda Don Juan", "Verduras, frutas y abarrotes"),
          _buildCommerceCard("Cafetería La Esquina", "Café, jugos naturales y desayunos"),
          _buildCommerceCard("Supermercado La 14", "Productos variados y domicilios"),
        ],
      ),
    );
  }

  Widget _buildCommerceCard(String name, String description) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(Icons.storefront, color: Colors.green),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          // Aquí puedes navegar a los productos del comercio
        },
      ),
    );
  }
}
