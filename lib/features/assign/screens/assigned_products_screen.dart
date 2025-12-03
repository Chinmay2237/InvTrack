import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/features/assign/providers/assign_provider.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/core/theme/app_text.dart';
import 'package:myapp/core/theme/app_spacing.dart';

class AssignedProductsScreen extends StatelessWidget {
  const AssignedProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assignProvider = Provider.of<AssignProvider>(context);
    final assignedItems = assignProvider.assignedItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Products'),
      ),
      body: assignedItems.isEmpty
          ? Center(
              child: Text('No products have been assigned yet.', style: AppText.bodyLarge.copyWith(color: AppColors.textSecondary)),
            )
          : ListView.builder(
              padding: AppSpacing.edgeInsetsAll16,
              itemCount: assignedItems.length,
              itemBuilder: (ctx, i) {
                final item = assignedItems[i];
                return Card(
                  margin: AppSpacing.edgeInsetsAll12,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(item.product.imageUrl),
                    ),
                    title: Text(item.product.name, style: AppText.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text('Assigned to: ${item.employeeName}\nAssigned on: ${item.assignmentDate.toLocal().toString().split(' ')[0]}', style: AppText.bodySmall.copyWith(color: AppColors.textSecondary)),
                    trailing: IconButton(
                      icon: const Icon(Icons.undo, color: AppColors.error),
                      onPressed: () {
                        assignProvider.unassignProduct(item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product unassigned.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
