import 'package:flutter/material.dart';
import 'store_products_screen.dart';

class ComercioCard extends StatelessWidget {
  final Map<String, dynamic> comercio;
  final bool isHorizontal;

  const ComercioCard({required this.comercio, this.isHorizontal = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoreProductsScreen(
              storeId: comercio['id'],
              storeName: comercio['name'],
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: isHorizontal ? const EdgeInsets.only(right: 12) : const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                comercio['image'] ?? '',
                height: isHorizontal ? 120 : 160,
                width: isHorizontal ? 160 : double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comercio['name'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(comercio['type'] ?? '', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
