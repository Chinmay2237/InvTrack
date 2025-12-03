import '../cart/models/cart_item.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  Order.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        amount = map['amount'],
        products = (map['products'] as List<dynamic>)
            .map((item) => CartItem.fromMap(item))
            .toList(),
        dateTime = DateTime.parse(map['dateTime']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
        'products': products.map((item) => item.toMap()).toList(),
        'dateTime': dateTime.toIso8601String(),
      };
}
