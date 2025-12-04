import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  List<Product> get lowStockItems => _products.where((p) => p.quantity <= 10).toList();

  ProductProvider() {
    _loadInitialProducts();
  }

  void _loadInitialProducts() {
    _products = [
      Product(
        id: 'p1',
        name: 'Monitor',
        description: 'A high-resolution computer monitor.',
        price: 250.00,
        category: 'Electronics',
        quantity: 15,
        imageUrl: 'assets/images/monitor.png',
      ),
      Product(
        id: 'p2',
        name: 'Mouse',
        description: 'An ergonomic wireless mouse.',
        price: 25.00,
        category: 'Accessories',
        quantity: 30,
        imageUrl: 'assets/images/mouse.png',
      ),
      Product(
        id: 'p3',
        name: 'Keyboard',
        description: 'A mechanical keyboard with RGB lighting.',
        price: 80.00,
        category: 'Accessories',
        quantity: 20,
        imageUrl: 'assets/images/keyboard.png',
      ),
      Product(
        id: 'p4',
        name: 'Cubicle Accessories Kit',
        description: 'A set of accessories for your cubicle.',
        price: 40.00,
        category: 'Office Supplies',
        quantity: 50,
        imageUrl: 'assets/images/cubicle_kit.png',
      ),
      Product(
        id: 'p5',
        name: 'Pipette',
        description: 'A calibrated pipette for laboratory use.',
        price: 120.00,
        category: 'Lab Equipment',
        quantity: 10,
        imageUrl: 'assets/images/pipette.png',
      ),
      Product(
        id: 'p6',
        name: 'Microscope',
        description: 'A high-power microscope for biological research.',
        price: 1500.00,
        category: 'Lab Equipment',
        quantity: 5,
        imageUrl: 'assets/images/microscope.png',
      ),
    ];
    notifyListeners();
  }

  Product findById(String id) {
    return _products.firstWhere((p) => p.id == id);
  }

  void addProduct(Product product, File? imageFile) {
    final newProduct = product.copyWith(
      id: DateTime.now().toString(),
      imageUrl: imageFile?.path,
    );
    _products.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _products.indexWhere((p) => p.id == id);
    if (prodIndex >= 0) {
      _products[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
