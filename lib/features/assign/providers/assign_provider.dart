import 'package:flutter/material.dart';
import '../models/assigned_item.dart';

class AssignProvider with ChangeNotifier {
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
