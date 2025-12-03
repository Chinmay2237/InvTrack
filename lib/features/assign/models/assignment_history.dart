import 'package:myapp/features/assign/models/handover_type.dart';
import 'package:myapp/features/products/models/product.dart';

class AssignmentHistory {
  final String id;
  final Product product;
  final String employeeName;
  final DateTime handoverDate;
  final HandoverType handoverType;
  final String? projectName;
  final DateTime? returnDate;

  AssignmentHistory({
    required this.id,
    required this.product,
    required this.employeeName,
    required this.handoverDate,
    required this.handoverType,
    this.projectName,
    this.returnDate,
  });
}
