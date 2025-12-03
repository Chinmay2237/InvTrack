import 'package:flutter/material.dart';

import '../../products/models/product.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, Product> _wishlistItems = {};

  Map<String, Product> get wishlistItems => {..._wishlistItems};

  void toggleWishlist(Product product) {
    if (_wishlistItems.containsKey(product.id)) {
      _wishlistItems.remove(product.id);
    } else {
      _wishlistItems[product.id] = product;
    }
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _wishlistItems.containsKey(productId);
  }
}
