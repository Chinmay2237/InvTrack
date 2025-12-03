import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'products';

  Stream<List<Product>> getProducts() {
    return _firestore.collection(_collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }

  Future<void> addProduct(Product product) async {
    await _firestore.collection(_collectionPath).add(product.toFirestore());
  }

  Future<void> updateProduct(Product product) async {
    await _firestore
        .collection(_collectionPath)
        .doc(product.id)
        .update(product.toFirestore());
  }

  Future<void> deleteProduct(String id) async {
    await _firestore.collection(_collectionPath).doc(id).delete();
  }

  Future<Product> getProductById(String id) async {
    DocumentSnapshot doc = await _firestore.collection(_collectionPath).doc(id).get();
    return Product.fromFirestore(doc);
  }
}
