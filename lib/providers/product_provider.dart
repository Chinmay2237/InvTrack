import 'package:flutter/material.dart';
import 'package:workshop_demo/models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Product 1',
      description: 'This is a description for product 1.',
      price: 29.99,
      stock: 10,
      category: 'Category A', lastUpdated: DateTime.now(),
    ),
    Product(
      id: '2',
      name: 'Product 2',
      description: 'This is a description for product 2.',
      price: 59.99,
      stock: 5,
      category: 'Category B', lastUpdated: DateTime.now(),
    ),
  ];

  List<Product> get products => _products;

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
