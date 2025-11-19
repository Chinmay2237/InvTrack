
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invtrack/features/products/models/product.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get a stream of products for a specific category
  Stream<List<Product>> getProducts(String category) {
    return _db
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .toList());
  }

  // Get a single product by its ID
  Future<Product> getProductById(String productId) {
    return _db
        .collection('products')
        .doc(productId)
        .get()
        .then((doc) => Product.fromFirestore(doc));
  }

  // Add a new product
  Future<void> addProduct(Product product) {
    return _db.collection('products').add(product.toFirestore());
  }

  // Update an existing product
  Future<void> updateProduct(Product product) {
    return _db
        .collection('products')
        .doc(product.id)
        .update(product.toFirestore());
  }

  // Delete a product
  Future<void> deleteProduct(String productId) {
    return _db.collection('products').doc(productId).delete();
  }

  // Get a stream of category counts
  Stream<Map<String, int>> getCategoryCounts() {
    return _db.collection('products').snapshots().map((snapshot) {
      final counts = <String, int>{};
      for (final doc in snapshot.docs) {
        final category = doc.data()['category'] as String?;
        if (category != null) {
          counts[category] = (counts[category] ?? 0) + 1;
        }
      }
      return counts;
    });
  }
}
