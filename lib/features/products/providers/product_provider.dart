import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  List<Product> get lowStockItems => _products.where((p) => p.quantity <= 10).toList();

  ProductProvider() {
    fetchAndSetProducts();
  }

  Future<void> fetchAndSetProducts() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDocDir.path}/products.csv';
    final file = File(filePath);

    if (await file.exists()) {
      final input = await file.readAsString();
      _parseCsv(input);
    } else {
      final data = await rootBundle.loadString('lib/data/products.csv');
      await file.writeAsString(data);
      _parseCsv(data);
    }
  }

  void _parseCsv(String data) {
    final List<List<dynamic>> csvTable = const CsvToListConverter().convert(data, eol: '\n');

    _products = csvTable.skip(1).map((row) {
      return Product(
        id: row[0].toString(),
        name: row[1].toString(),
        description: row[2].toString(),
        price: double.parse(row[3].toString()),
        category: row[4].toString(),
        quantity: int.parse(row[5].toString()),
        imageUrl: row[6].toString(),
      );
    }).toList();
    notifyListeners();
  }


  Future<void> _saveProducts() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDocDir.path}/products.csv';
    final file = File(filePath);

    List<List<dynamic>> csvData = [
      ['id', 'name', 'description', 'price', 'category', 'quantity', 'imageUrl'],
      ..._products.map((p) => [p.id, p.name, p.description, p.price, p.category, p.quantity, p.imageUrl])
    ];

    String csv = const ListToCsvConverter().convert(csvData, eol: '\n');
    await file.writeAsString(csv);
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
    _saveProducts();
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _products.indexWhere((p) => p.id == id);
    if (prodIndex >= 0) {
      _products[prodIndex] = newProduct;
      _saveProducts();
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    _saveProducts();
    notifyListeners();
  }
}
