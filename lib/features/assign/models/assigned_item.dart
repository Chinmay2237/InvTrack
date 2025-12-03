import 'package:myapp/features/products/models/product.dart';
import 'package:myapp/features/assign/models/handover_type.dart';
import 'package:myapp/features/assign/models/assignment_history.dart';

class AssignedItem {
  final String id;
  final Product product;
  final String employeeName;
  final DateTime assignmentDate;
  final HandoverType handoverType;
  final String? projectName;
  final List<AssignmentHistory> history;

  AssignedItem({
    required this.id,
    required this.product,
    required this.employeeName,
    required this.assignmentDate,
    required this.handoverType,
    this.projectName,
    this.history = const [],
  });
}
