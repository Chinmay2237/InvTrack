import 'package:flutter/foundation.dart';
import '../../products/models/product.dart';
import '../../products/providers/product_provider.dart';

class SearchProvider with ChangeNotifier {
  final ProductProvider _productProvider;
  List<Product> _searchResults = [];
  String _query = '';

  SearchProvider(this._productProvider);

  List<Product> get searchResults => _searchResults;
  String get query => _query;

  void search(String query) {
    _query = query;
    if (query.isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = _productProvider.products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
