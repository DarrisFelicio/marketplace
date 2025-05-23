import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });

  // Convert a CartItem into a Map. The keys must correspond to the names of the
  // properties themselves.
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'quantity': quantity, 'price': price};
  }

  // Create a CartItem from a Map.
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      title: json['title'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};
  static const String _cartKey = 'cartItems'; // Key for SharedPreferences

  CartProvider() {
    _loadCartItems(); // Load cart items when the provider is initialized
  }

  Map<String, CartItem> get items {
    return {..._items}; // Return a copy
  }

  int get itemCount {
    return _items.length;
  }

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // update quantity
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    _saveCartItems(); // Save changes to local storage
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    _saveCartItems(); // Save changes to local storage
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    _saveCartItems(); // Clear local storage
    notifyListeners();
  }

  // --- Local Storage Methods ---

  Future<void> _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        _items.values.map((item) => item.toJson()).toList();
    await prefs.setString(_cartKey, jsonEncode(jsonList));
  }

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_cartKey)) {
      return;
    }
    final String? jsonString = prefs.getString(_cartKey);
    if (jsonString != null) {
      final List<dynamic> decodedList = jsonDecode(jsonString);
      _items = {
        for (var itemMap in decodedList)
          (itemMap as Map<String, dynamic>)['id'] as String: CartItem.fromJson(
            itemMap,
          ),
      };
      notifyListeners();
    }
  }
}
