import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/features/products/models/product.dart';
import 'package:myapp/features/products/models/stock_filter.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];
  String _searchTerm = '';
  StockFilter _filter = StockFilter.all;

  // Dummy data generation
  ProductProvider() {
    if (_items.isEmpty) {
      _generateDummyProducts();
    }
  }

  void _generateDummyProducts() {
    final Random random = Random();
    final categories = ['Electronics', 'Furniture', 'Stationery', 'Office Supplies', 'Accessories'];
    _items = List.generate(50, (index) {
      final id = 'p${index + 1}';
      final quantity = random.nextInt(25); // Random quantity between 0 and 24
      return Product(
        id: id,
        name: 'Product ${index + 1}',
        category: categories[random.nextInt(categories.length)],
        description: 'This is a detailed description for product ${index + 1}. It highlights the key features, benefits, and specifications of the item, ensuring the customer has all the information they need.',
        price: (random.nextDouble() * 100).clamp(10, 100), // Random price between 10 and 100
        imageUrl: 'https://picsum.photos/seed/$id/400/400',
        quantity: quantity,
      );
    });
  }

  List<Product> get items {
    List<Product> filteredItems = [..._items];

    if (_searchTerm.isNotEmpty) {
      filteredItems = filteredItems
          .where((prod) => prod.name.toLowerCase().contains(_searchTerm.toLowerCase()))
          .toList();
    }

    switch (_filter) {
      case StockFilter.inStock:
        return filteredItems.where((prod) => prod.quantity > 10).toList();
      case StockFilter.lowStock:
        return filteredItems.where((prod) => prod.quantity <= 10 && prod.quantity > 0).toList();
      case StockFilter.outOfStock:
        return filteredItems.where((prod) => prod.quantity == 0).toList();
      case StockFilter.all:
      default:
        return filteredItems;
    }
  }

  List<Product> get justInItems {
    // Simulate "Just In" items by taking the most recently added items.
    // In a real app, this would be based on a creation timestamp.
    return _items.length > 5 ? _items.sublist(0, 5) : _items;
  }

  List<Product> get officeItems {
    // A subset of items for general office use.
    return _items.where((p) => p.category == 'Stationery' || p.category == 'Office Supplies').toList();
  }

  List<Product> get lowStockItems {
    return _items.where((prod) => prod.quantity <= 10 && prod.quantity > 0).toList();
  }

  List<Product> get outOfStockItems {
    return _items.where((prod) => prod.quantity == 0).toList();
  }

  double get totalInventoryValue {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, you'd fetch from an API
    // For now, we just ensure dummy data is generated
    if (_items.isEmpty) {
      _generateDummyProducts();
    }
    notifyListeners();
  }

  Future<void> addProduct(Product product, File? image) async {
    // In a real app, you would upload the image to cloud storage and get a URL
    final newProduct = product.copyWith(
      id: 'p${DateTime.now().toIso8601String()}',
      // Use a placeholder if no image is provided
      imageUrl: image != null ? 'https://picsum.photos/seed/${DateTime.now().toIso8601String()}/400/400' : 'https://picsum.photos/seed/placeholder/400/400',
    );
    _items.insert(0, newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  void searchProducts(String searchTerm) {
    _searchTerm = searchTerm;
    notifyListeners();
  }

  void setFilter(StockFilter filter) {
    _filter = filter;
    notifyListeners();
  }
  
  void clearProducts() {
    _items = [];
    notifyListeners();
  }
}
