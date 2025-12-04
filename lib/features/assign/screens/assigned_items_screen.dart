import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assign_provider.dart';

class AssignedItemsScreen extends StatelessWidget {
  const AssignedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assignedItems = Provider.of<AssignProvider>(context).assignedItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Products'),
      ),
      body: ListView.builder(
        itemCount: assignedItems.length,
        itemBuilder: (context, index) {
          final item = assignedItems[index];
          return ListTile(
            title: Text('Product ID: ${item.productId}'),
            subtitle: Text('Employee ID: ${item.employeeId}'),
            trailing: Text('Quantity: ${item.quantity}'),
          );
        },
      ),
    );
  }
}
