class Product {
  final String id;
  final String name;
  final String serialNumber;
  final String category;
  final double cost;
  final double price;
  final String assignedTo;
  final String notes;
  final String imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.category,
    required this.cost,
    required this.price,
    required this.assignedTo,
    required this.notes,
    this.imageUrl = '',
    this.createdAt,
    this.updatedAt,
  });

  Product copyWith({
    String? id,
    String? name,
    String? serialNumber,
    String? category,
    double? cost,
    double? price,
    String? assignedTo,
    String? notes,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      serialNumber: serialNumber ?? this.serialNumber,
      category: category ?? this.category,
      cost: cost ?? this.cost,
      price: price ?? this.price,
      assignedTo: assignedTo ?? this.assignedTo,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
