import 'package:flutter/material.dart';
import '../models/assigned_item.dart';

class AssignProvider with ChangeNotifier {
  final List<Map<String, String>> _employees = [
    {'id': 'E1', 'name': 'Alice'},
    {'id': 'E2', 'name': 'Bob'},
    {'id': 'E3', 'name': 'Charlie'},
    {'id': 'E4', 'name': 'Diana'},
  ];

  List<Map<String, String>> get employees => _employees;

  String getEmployeeName(String id) {
    return _employees.firstWhere((emp) => emp['id'] == id, orElse: () => {'name': 'Unknown'})['name']!;
  }

  List<AssignedItem> _assignedItems = [];

  List<AssignedItem> get assignedItems => _assignedItems;

  void assignProduct(String productId, String employeeId, int quantity) {
    _assignedItems.add(AssignedItem(
      id: DateTime.now().toString(),
      productId: productId,
      employeeId: employeeId,
      assignedDate: DateTime.now(),
      quantity: quantity,
    ));
    notifyListeners();
  }
}
