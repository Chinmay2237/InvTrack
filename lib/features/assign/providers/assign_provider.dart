import 'package:flutter/material.dart';
import 'package:myapp/features/assign/models/assigned_item.dart';
import 'package:myapp/features/products/models/product.dart';
import 'package:myapp/features/assign/models/handover_type.dart';
import 'package:myapp/features/assign/models/assignment_history.dart';

class AssignProvider with ChangeNotifier {
  final List<AssignedItem> _assignedItems = [];
  final Map<String, List<AssignmentHistory>> _history = {};

  List<AssignedItem> get assignedItems => [..._assignedItems];
  Map<String, List<AssignmentHistory>> get history => _history;

  void assignProduct(Product product, String employeeName, HandoverType handoverType, {String? projectName}) {
    final assignmentId = DateTime.now().toIso8601String();
    final newHistoryItem = AssignmentHistory(
      id: assignmentId,
      product: product,
      employeeName: employeeName,
      handoverDate: DateTime.now(),
      handoverType: handoverType,
      projectName: projectName,
    );

    final newAssignment = AssignedItem(
      id: assignmentId,
      product: product,
      employeeName: employeeName,
      assignmentDate: DateTime.now(),
      handoverType: handoverType,
      projectName: projectName,
      history: [newHistoryItem],
    );

    _assignedItems.add(newAssignment);
    _history.update(product.id, (list) => list..add(newHistoryItem), ifAbsent: () => [newHistoryItem]);
    notifyListeners();
  }

  void unassignProduct(String assignId) {
    final itemIndex = _assignedItems.indexWhere((item) => item.id == assignId);
    if (itemIndex != -1) {
      final item = _assignedItems[itemIndex];
      final historyItemIndex = _history[item.product.id]?.indexWhere((h) => h.id == assignId);
      if (historyItemIndex != null && historyItemIndex != -1) {
        _history[item.product.id]![historyItemIndex] = AssignmentHistory(
          id: item.id,
          product: item.product,
          employeeName: item.employeeName,
          handoverDate: item.assignmentDate,
          handoverType: item.handoverType,
          projectName: item.projectName,
          returnDate: DateTime.now(),
        );
      }
      _assignedItems.removeAt(itemIndex);
      notifyListeners();
    }
  }

  bool isAssigned(String productId) {
    return _assignedItems.any((item) => item.product.id == productId);
  }

  Map<String, int> get projectAssetCounts {
    final counts = <String, int>{};
    for (final item in _assignedItems) {
      if (item.projectName != null) {
        counts[item.projectName!] = (counts[item.projectName] ?? 0) + 1;
      }
    }
    return counts;
  }
}
