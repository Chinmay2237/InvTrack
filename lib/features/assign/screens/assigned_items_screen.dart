import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/assign_provider.dart';
import '../../products/providers/product_provider.dart';

class AssignedItemsScreen extends StatelessWidget {
  const AssignedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final assignedItems = Provider.of<AssignProvider>(context).assignedItems;
    final productProvider = Provider.of<ProductProvider>(context);
    final assignProvider = Provider.of<AssignProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Products'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: assignedItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 20),
                  Text('No products have been assigned yet.', style: theme.textTheme.titleMedium),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: assignedItems.length,
              itemBuilder: (context, index) {
                final item = assignedItems[index];
                final product = productProvider.findById(item.productId);
                final employeeName = assignProvider.getEmployeeName(item.employeeId);

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      foregroundColor: theme.colorScheme.primary,
                      child: const Icon(Icons.person_pin_rounded),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Assigned to: $employeeName'),
                        const SizedBox(height: 4),
                        Text('Date: ${DateFormat.yMMMd().format(item.assignedDate)}'),
                      ],
                    ),
                    trailing: Text(
                      'Qty: ${item.quantity}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
