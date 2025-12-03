class Product {
  String id;
  String name;
  String description;
  double price;
  int quantity;
  String? category;
  String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.category,
    this.imageUrl,
  });
}
