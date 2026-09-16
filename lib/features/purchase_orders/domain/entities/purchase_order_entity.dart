class PurchaseOrderItemEntity {
  final String id;
  final String poId;
  final String itemId;
  final int orderedQty;
  final int receivedQty;
  final double unitCost;

  const PurchaseOrderItemEntity({
    required this.id,
    required this.poId,
    required this.itemId,
    required this.orderedQty,
    this.receivedQty = 0,
    required this.unitCost,
  });
}

class PurchaseOrderEntity {
  final String id;
  final String poNumber;
  final String supplierId;
  final String status; // 'draft', 'submitted', 'received'
  final DateTime createdAt;
  final DateTime? expectedDate;
  final List<PurchaseOrderItemEntity> items;

  const PurchaseOrderEntity({
    required this.id,
    required this.poNumber,
    required this.supplierId,
    this.status = 'draft',
    required this.createdAt,
    this.expectedDate,
    this.items = const [],
  });
}
