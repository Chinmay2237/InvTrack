import 'package:flutter/material.dart';
import '../models/product.dart';
import 'dart:math';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
        id: '1',
        name: 'Laptop',
        description: 'A high-end gaming laptop',
        price: 1200.00,
        quantity: 10,
        category: 'Electronics',
        imageUrl:
            'https://images.pexels.com/photos/205421/pexels-photo-205421.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
    Product(
        id: '2',
        name: 'Keyboard',
        description: 'A mechanical keyboard',
        price: 150.00,
        quantity: 25,
        category: 'Electronics',
        imageUrl:
            'https://images.pexels.com/photos/841228/pexels-photo-841228.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
    Product(
        id: '3',
        name: 'Mouse',
        description: 'An ergonomic mouse',
        price: 75.00,
        quantity: 50,
        category: 'Electronics',
        imageUrl:
            'https://images.pexels.com/photos/2115256/pexels-photo-2115256.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
    Product(
        id: '4',
        name: 'Monitor',
        description: 'A 4K monitor',
        price: 400.00,
        quantity: 15,
        category: 'Electronics',
        imageUrl:
            'https://images.pexels.com/photos/1029757/pexels-photo-1029757.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
    Product(
        id: '5',
        name: 'Chair',
        description: 'An office chair',
        price: 250.00,
        quantity: 20,
        category: 'Furniture',
        imageUrl:
            'https://images.pexels.com/photos/2762247/pexels-photo-2762247.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
    Product(
        id: '6',
        name: 'Desk',
        description: 'A standing desk',
        price: 500.00,
        quantity: 12,
        category: 'Furniture',
        imageUrl:
            'https://images.pexels.com/photos/1957478/pexels-photo-1957478.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
  ];

  List<Product> get products => _products;

  void addProduct(Product product) {
    final newProduct = Product(
        id: Random().nextDouble().toString(),
        name: product.name,
        description: product.description,
        price: product.price,
        quantity: product.quantity,
        category: product.category,
        imageUrl: product.imageUrl);
    _products.add(newProduct);
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

  Product getProductById(String id) {
    return _products.firstWhere((p) => p.id == id);
  }
}
