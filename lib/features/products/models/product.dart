import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String serialNumber;
  final String category;
  final double cost;
  final String assignedTo;
  final String notes;
  final String imageUrl; // Optional
  final DateTime? createdAt; // Made nullable
  final DateTime? updatedAt; // Made nullable

  Product({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.category,
    required this.cost,
    required this.assignedTo,
    required this.notes,
    this.imageUrl = '', // Default to empty string if not provided
    this.createdAt, // No longer required
    this.updatedAt, // No longer required
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      serialNumber: data['serialNumber'] ?? '',
      category: data['category'] ?? '',
      cost: (data['cost'] ?? 0.0).toDouble(),
      assignedTo: data['assignedTo'] ?? '',
      notes: data['notes'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(), // Safely parse nullable Timestamp
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(), // Safely parse nullable Timestamp
    );
  }

  // This method is for creating a new document or fully replacing an existing one
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'serialNumber': serialNumber,
      'category': category,
      'cost': cost,
      'assignedTo': assignedTo,
      'notes': notes,
      'imageUrl': imageUrl,
      // createdAt should only be set on initial creation by the service
      // updatedAt should always be updated by the service
    };
  }

  // Helper method for updating specific fields without recreating the entire object for Firestore
  Map<String, dynamic> toUpdateFirestore() {
    return {
      'name': name,
      'serialNumber': serialNumber,
      'category': category,
      'cost': cost,
      'assignedTo': assignedTo,
      'notes': notes,
      'imageUrl': imageUrl,
      // 'updatedAt': FieldValue.serverTimestamp(), // This will be handled by the service now
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? serialNumber,
    String? category,
    double? cost,
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
      assignedTo: assignedTo ?? this.assignedTo,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}