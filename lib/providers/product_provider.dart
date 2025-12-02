
import 'package:flutter/material.dart';
import 'package:workshop_demo/data/services/demo_api_service.dart';
import 'package:workshop_demo/models/product.dart';

class ProductProvider extends ChangeNotifier {
  final DemoApiService apiService;

  ProductProvider({required this.apiService});

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await apiService.getProducts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      final newProduct = await apiService.addProduct(productData);
      _products.add(newProduct);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> productData) async {
    try {
      final updatedProduct = await apiService.updateProduct(id, productData);
      if (updatedProduct != null) {
        final index = _products.indexWhere((p) => p.id == id);
        if (index != -1) {
          _products[index] = updatedProduct;
          notifyListeners();
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final success = await apiService.deleteProduct(id);
      if (success) {
        _products.removeWhere((p) => p.id == id);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
