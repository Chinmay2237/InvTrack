import 'package:flutter/foundation.dart';
import 'package:workshop_demo/models/product.dart';
import 'dart:math';

class InventoryProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
        id: '1',
        name: 'Laptop',
        description: 'A high-end gaming laptop',
        price: 1500.00,
        stock: 10,
        category: 'Electronics',
        lastUpdated: DateTime.now()),
    Product(
        id: '2',
        name: 'Keyboard',
        description: 'A mechanical keyboard',
        price: 120.00,
        stock: 25,
        category: 'Electronics',
        lastUpdated: DateTime.now()),
    Product(
        id: '3',
        name: 'Mouse',
        description: 'An ergonomic mouse',
        price: 75.00,
        stock: 50,
        category: 'Electronics',
        lastUpdated: DateTime.now()),
  ];

  List<Product> get products => _products;

  Product findById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) {
    final newProduct = Product(
      id: Random().nextDouble().toString(),
      name: product.name,
      description: product.description,
      price: product.price,
      stock: product.stock,
      category: product.category,
      lastUpdated: DateTime.now(),
    );
    _products.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _products.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _products[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
