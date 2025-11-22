import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:invtrack/core/models/history.dart'; // Import the History model
import 'package:invtrack/features/products/models/product.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CollectionReference _historyCollection = FirebaseFirestore.instance
      .collection('history'); // Added history collection reference

  // Get a stream of products, optionally filtered by category
  Stream<List<Product>> getProducts({String? category}) {
    Query query = _db.collection('products');
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  // Get all products
  Future<List<Product>> getAllProducts() async {
    final querySnapshot = await _db.collection('products').get();
    return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  // Get a stream of all products
  Stream<List<Product>> getProductsStream() {
    return _db.collection('products').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  // Get a stream of recently added products
  Stream<List<Product>> getRecentProducts({int limit = 5}) {
    return _db
        .collection('products')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }
  
  // Get a stream of all unique product categories
  Stream<List<String>> getProductCategoriesStream() {
    return _db.collection('products').snapshots().map((snapshot) {
      final categories = snapshot.docs
          .map((doc) => doc.data()['category'] as String?)
          .where((category) => category != null)
          .toSet()
          .toList();
      categories.sort();
      return categories;
    });
  }


  // Get a single product by its ID
  Future<Product> getProductById(String productId) async {
    final docSnapshot = await _db.collection('products').doc(productId).get();
    if (docSnapshot.exists) {
      return Product.fromFirestore(docSnapshot);
    } else {
      throw Exception('Product with ID $productId not found.');
    }
  }

  // Add a new product
  Future<void> addProduct(Product product) async {
    final data = product.toFirestore();
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    data['price'] = product.price;
    data.remove('id');
    final docRef = await _db.collection('products').add(data);

    // Add history entry for product creation
    final newProduct = product.copyWith(
        id: docRef.id); // Create a product with the generated ID for history
    await addHistoryEntry(
      History(
        id: '', // Firestore will generate this
        productId: docRef.id,
        action: 'created',
        timestamp: DateTime
            .now(), // Will be overwritten by FieldValue.serverTimestamp()
        details: 'Product "${newProduct.name}" created.',
      ),
    );
  }

  // Update an existing product
  Future<void> updateProduct(Product product) async {
    final data = product.toFirestore();
    data['updatedAt'] = FieldValue.serverTimestamp();
    data['price'] = product.price;
    data.remove('id');
    await _db.collection('products').doc(product.id).update(data);

    // Add history entry for product update
    await addHistoryEntry(
      History(
        id: '', // Firestore will generate this
        productId: product.id,
        action: 'updated',
        timestamp: DateTime
            .now(), // Will be overwritten by FieldValue.serverTimestamp()
        details: 'Product "${product.name}" updated.',
      ),
    );
  }

  // Delete a product
  Future<void> deleteProduct(String productId) {
    return _db.collection('products').doc(productId).delete();
  }

  // Upload product image to Firebase Storage
  Future<String?> uploadProductImage(
      String productId, Uint8List imageData, String imageName) async {
    try {
      final ref = _storage.ref().child('products/$productId/$imageName');
      final uploadTask = ref.putData(imageData);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e, s) {
      developer.log('Error uploading image', error: e, stackTrace: s);
      return null;
    }
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

  // Add a new history entry
  Future<void> addHistoryEntry(History history) async {
    final data = history.toFirestore();
    data['timestamp'] =
        FieldValue.serverTimestamp(); // Ensure timestamp is set on creation
    data.remove('id'); // Firestore will generate the ID
    await _historyCollection.add(data);
  }

  // Retrieve history entries for a specific product, ordered by timestamp
  Stream<List<History>> getProductHistory(String productId) {
    return _historyCollection
        .where('productId', isEqualTo: productId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => History.fromFirestore(doc)).toList());
  }
}
