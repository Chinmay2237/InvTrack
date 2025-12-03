import 'package:flutter/foundation.dart';
import 'package:myapp/features/products/models/product.dart';

@immutable
class Assign {
  final String id;
  final Product product;
  final String employeeName;
  final DateTime assignDate;

  const Assign({
    required this.id,
    required this.product,
    required this.employeeName,
    required this.assignDate,
  });

  Assign copyWith({
    String? id,
    Product? product,
    String? employeeName,
    DateTime? assignDate,
  }) {
    return Assign(
      id: id ?? this.id,
      product: product ?? this.product,
      employeeName: employeeName ?? this.employeeName,
      assignDate: assignDate ?? this.assignDate,
    );
  }
}
