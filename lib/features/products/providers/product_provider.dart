import 'dart:math';

import 'package:flutter/material.dart';
import 'package:workshop_demo/features/products/models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => _products;

  void addProduct(Map<String, dynamic> productData) {
    final newProduct = Product(
      id: Random().nextInt(1000).toString(),
      name: productData['name'],
      serialNumber: productData['serialNumber'],
      category: productData['category'],
      cost: productData['cost'],
      price: productData['price'],
      assignedTo: productData['assignedTo'],
      notes: productData['notes'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _products.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Map<String, dynamic> productData) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index] = _products[index].copyWith(
        name: productData['name'],
        serialNumber: productData['serialNumber'],
        category: productData['category'],
        cost: productData['cost'],
        price: productData['price'],
        assignedTo: productData['assignedTo'],
        notes: productData['notes'],
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  Product findById(String id) {
    return _products.firstWhere((p) => p.id == id);
  }
}
