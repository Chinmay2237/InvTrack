class SalesOrderItemEntity {
  final String id;
  final String orderId;
  final String itemId;
  final int quantity;
  final double unitPrice;

  const SalesOrderItemEntity({
    required this.id,
    required this.orderId,
    required this.itemId,
    required this.quantity,
    required this.unitPrice,
  });
}

class SalesOrderEntity {
  final String id;
  final String orderNumber;
  final String? customerName;
  final String status; // 'pending', 'fulfilled'
  final double totalAmount;
  final DateTime createdAt;
  final List<SalesOrderItemEntity> items;

  const SalesOrderEntity({
    required this.id,
    required this.orderNumber,
    this.customerName,
    this.status = 'pending',
    required this.totalAmount,
    required this.createdAt,
    this.items = const [],
  });
}
