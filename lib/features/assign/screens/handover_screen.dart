import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/features/assign/providers/assign_provider.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/core/theme/app_text.dart';
import 'package:myapp/core/theme/app_spacing.dart';
import 'package:myapp/features/assign/models/handover_type.dart';

class HandoversScreen extends StatelessWidget {
  const HandoversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assignProvider = Provider.of<AssignProvider>(context);
    final assignedItems = assignProvider.assignedItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('Handovers', style: AppText.headlineSmall.copyWith(color: AppColors.primary)),
        backgroundColor: AppColors.appBarBackgroundColor,
      ),
      body: assignedItems.isEmpty
          ? Center(
              child: Text('No products handed over yet.', style: AppText.bodyLarge),
            )
          : ListView.builder(
              itemCount: assignedItems.length,
              itemBuilder: (context, index) {
                final item = assignedItems[index];
                return Card(
                  margin: AppSpacing.edgeInsetsSymmetricH16,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(item.product.imageUrl),
                    ),
                    title: Text(item.product.name, style: AppText.titleMedium),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('To: ${item.employeeName}'),
                        const SizedBox(height: 4),
                        Text('Type: ${item.handoverType.toString().split('.').last}'),
                        if (item.projectName != null) ...[
                          const SizedBox(height: 4),
                          Text('Project: ${item.projectName}'),
                        ],
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.undo, color: AppColors.primary),
                      onPressed: () => assignProvider.unassignProduct(item.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
