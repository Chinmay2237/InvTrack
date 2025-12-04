import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/features/assign/providers/assign_provider.dart';

class AssignedProductsScreen extends StatelessWidget {
  const AssignedProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final assignProvider = Provider.of<AssignProvider>(context);
    final assignedItems = assignProvider.assignedItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Products'),
      ),
      body: assignedItems.isEmpty
          ? Center(
              child: Text(
                'No products have been assigned yet.',
                style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: assignedItems.length,
              itemBuilder: (ctx, i) {
                final item = assignedItems[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(item.product.imageUrl),
                      onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.image),
                    ),
                    title: Text(item.product.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'To: ${item.employeeName} on ${item.assignmentDate.toLocal().toString().split(' ')[0]}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.undo, color: Colors.redAccent),
                      tooltip: 'Unassign',
                      onPressed: () {
                        _showUnassignConfirmation(context, assignProvider, item.id);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showUnassignConfirmation(BuildContext context, AssignProvider provider, String assignId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Unassignment'),
        content: const Text('Are you sure you want to unassign this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.unassignProduct(assignId);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product has been unassigned.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Unassign'),
          ),
        ],
      ),
    );
  }
}
