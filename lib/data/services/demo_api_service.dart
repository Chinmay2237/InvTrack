
import 'dart:convert';
import 'dart:math';

import 'package:workshop_demo/models/product.dart';

class DemoApiService {
  // In-memory product list to simulate a database
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Laptop',
      description: 'A high-end gaming laptop',
      price: 1500.00,
      stock: 10,
    ),
    Product(
      id: '2',
      name: 'Mouse',
      description: 'A wireless ergonomic mouse',
      price: 50.00,
      stock: 50,
    ),
    Product(
      id: '3',
      name: 'Keyboard',
      description: 'A mechanical keyboard with RGB lighting',
      price: 120.00,
      stock: 30,
    ),
    Product(
      id: '4',
      name: 'Monitor',
      description: 'A 27-inch 4K monitor',
      price: 450.00,
      stock: 20,
    ),
    Product(
      id: '5',
      name: 'Webcam',
      description: 'A 1080p webcam with a built-in microphone',
      price: 80.00,
      stock: 40,
    ),
  ];

  // Simulate network latency
  Future<void> _simulateLatency() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Fetch all products
  Future<List<Product>> getProducts() async {
    await _simulateLatency();
    return _products;
  }

  // Fetch a single product by ID
  Future<Product?> getProductById(String id) async {
    await _simulateLatency();
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add a new product
  Future<Product> addProduct(Map<String, dynamic> productData) async {
    await _simulateLatency();
    final newProduct = Product(
      id: (Random().nextInt(1000) + 10).toString(), // Generate a random ID
      name: productData['name'],
      description: productData['description'],
      price: productData['price'],
      stock: productData['stock'],
    );
    _products.add(newProduct);
    return newProduct;
  }

  // Update an existing product
  Future<Product?> updateProduct(String id, Map<String, dynamic> productData) async {
    await _simulateLatency();
    try {
      final productIndex = _products.indexWhere((product) => product.id == id);
      if (productIndex != -1) {
        final updatedProduct = Product(
          id: id,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          stock: productData['stock'],
        );
        _products[productIndex] = updatedProduct;
        return updatedProduct;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // Delete a product
  Future<bool> deleteProduct(String id) async {
    await _simulateLatency();
    try {
      _products.removeWhere((product) => product.id == id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
