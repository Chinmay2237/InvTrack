import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../../cart/models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
