// lib/providers/cart_provider.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartProvider with ChangeNotifier {
  final Map<String, List<Map<String, dynamic>>> _userCarts = {};

  String get _userId => FirebaseAuth.instance.currentUser?.uid ?? 'anon';

  List<Map<String, dynamic>> get items => _userCarts[_userId] ?? [];

  int get itemCount => items.length;

  void addItem(Map<String, dynamic> product) {
    final currentCart = _userCarts[_userId] ?? [];
    currentCart.add(product);
    _userCarts[_userId] = currentCart;
    notifyListeners();
  }

  void removeItem(int index) {
    if (_userCarts[_userId] != null) {
      _userCarts[_userId]!.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _userCarts[_userId] = [];
    notifyListeners();
  }
}
