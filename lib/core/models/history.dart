
import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  final String id;
  final String productId;
  final String action;
  final DateTime timestamp;
  final String? details; // Made optional

  History({
    required this.id,
    required this.productId,
    required this.action,
    required this.timestamp,
    this.details,
  });

  factory History.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return History(
      id: doc.id,
      productId: data['productId'] ?? '',
      action: data['action'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      details: data['details'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'action': action,
      'timestamp': FieldValue.serverTimestamp(), // Set server timestamp on creation
      'details': details,
    };
  }
}
