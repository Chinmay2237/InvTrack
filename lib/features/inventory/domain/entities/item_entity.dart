class ItemEntity {
  final String id;
  final String sku;
  final String name;
  final String? description;
  final String? barcode;
  final String? categoryId;
  final double costPrice;
  final double salePrice;
  final double taxRate;
  final String unitOfMeasure;
  final int reorderPoint;
  final String? imageUrl;
  final String? batchNumber;
  final DateTime? expiryDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ItemEntity({
    required this.id,
    required this.sku,
    required this.name,
    this.description,
    this.barcode,
    this.categoryId,
    this.costPrice = 0.0,
    this.salePrice = 0.0,
    this.taxRate = 0.0,
    this.unitOfMeasure = 'each',
    this.reorderPoint = 5,
    this.imageUrl,
    this.batchNumber,
    this.expiryDate,
    required this.createdAt,
    required this.updatedAt,
  });
}
