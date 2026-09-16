import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/tokens.dart';
import '../../scanning/presentation/widgets/barcode_label_dialog.dart';
import 'providers/inventory_provider.dart';

import '../../handovers/domain/entities/handover_entity.dart';
import '../../handovers/presentation/providers/handover_provider.dart';

final itemStockLevelsProvider =
    StreamProvider.family<List<StockLevel>, String>((ref, itemId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.stockLevels)..where((t) => t.itemId.equals(itemId)))
      .watch();
});

final itemHandoversProvider =
    StreamProvider.family<List<HandoverEntity>, String>((ref, itemId) {
  final repo = ref.watch(handoverRepositoryProvider);
  return repo
      .watchHandovers()
      .map((rows) => rows.where((h) => h.itemId == itemId).toList());
});

class ItemDetailScreen extends ConsumerWidget {
  final String itemId;

  const ItemDetailScreen({
    super.key,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(itemDetailProvider(itemId));
    final stocksAsync = ref.watch(itemStockLevelsProvider(itemId));
    final handoversAsync = ref.watch(itemHandoversProvider(itemId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Detail'),
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => context.go('/inventory'),
        ),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.edit),
            tooltip: 'Edit Item',
            onPressed: () => context.go('/inventory/$itemId/edit'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: itemAsync.when(
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Item not found'));
          }

          final totalStock = stocksAsync.maybeWhen(
            data: (stocks) => stocks.fold<int>(0, (sum, s) => sum + s.quantity),
            orElse: () => 0,
          );

          final margin = item.salePrice > 0
              ? (((item.salePrice - item.costPrice) / item.salePrice) * 100)
                  .toStringAsFixed(1)
              : '0.0';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppTokens.primarySurfaceLight,
                            borderRadius:
                                BorderRadius.circular(AppTokens.radiusModal),
                          ),
                          child: const Icon(AppIcons.asset,
                              size: 48, color: AppTokens.primary),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTokens.primarySurfaceLight,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'SKU: ${item.sku}',
                                      style: const TextStyle(
                                        color: AppTokens.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (item.barcode != null)
                                    Text(
                                      'Barcode: ${item.barcode}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.name,
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              if (item.description != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.description!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Primary Quick Actions Bar
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.go('/handovers/new');
                        },
                        icon: const Icon(AppIcons.assignment, size: 18),
                        label: const Text('Assign Asset Handover'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => BarcodeLabelDialog(
                            code: item.barcode ?? item.sku,
                            itemName: item.name,
                            sku: item.sku,
                          ),
                        );
                      },
                      icon: const Icon(AppIcons.scanActive, size: 18),
                      label: const Text('Print Label'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // KPI Stat Cards Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatTile(
                        context,
                        title: 'Total Stock',
                        value: '$totalStock ${item.unitOfMeasure}',
                        icon: AppIcons.assetGroup,
                        color: totalStock <= item.reorderPoint
                            ? AppTokens.warning
                            : AppTokens.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatTile(
                        context,
                        title: 'Selling Price',
                        value: '\$${item.salePrice.toStringAsFixed(2)}',
                        icon: AppIcons.available,
                        color: AppTokens.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatTile(
                        context,
                        title: 'Profit Margin',
                        value: '$margin%',
                        icon: AppIcons.sort,
                        color: AppTokens.info,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Reorder Banner if stock is low
                if (totalStock <= item.reorderPoint)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTokens.warningSurfaceDark
                          : AppTokens.warningSurfaceLight,
                      borderRadius: BorderRadius.circular(AppTokens.radiusCard),
                      border: Border.all(color: AppTokens.warning),
                    ),
                    child: Row(
                      children: [
                        const Icon(AppIcons.warning,
                            color: AppTokens.warning, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Low Stock Alert Triggered',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppTokens.warning,
                                    ),
                              ),
                              Text(
                                'Stock ($totalStock) is below reorder point threshold (${item.reorderPoint}).',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              context.go('/settings/purchase-orders'),
                          child: const Text('Reorder'),
                        ),
                      ],
                    ),
                  ),

                // Vertical Asset Handover Timeline (Section 6.8 spec)
                Text(
                  'Asset Handover History',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                handoversAsync.when(
                  data: (handovers) {
                    if (handovers.isEmpty) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(AppIcons.assignment,
                                    size: 36,
                                    color: AppTokens.textSecondaryLight),
                                const SizedBox(height: 8),
                                Text(
                                  'No handovers logged for this item yet.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: handovers.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final h = handovers[index];
                          final isPerm = h.assignmentType == 'permanent';
                          final isOverdue = h.status == 'overdue';

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isOverdue
                                  ? AppTokens.criticalSurfaceLight
                                  : (isPerm
                                      ? AppTokens.primarySurfaceLight
                                      : AppTokens.infoSurfaceLight),
                              child: Icon(
                                isPerm ? AppIcons.assignment : AppIcons.history,
                                color: isOverdue
                                    ? AppTokens.critical
                                    : (isPerm
                                        ? AppTokens.primary
                                        : AppTokens.info),
                                size: 20,
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  'Assigned to ${h.employeeId}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isPerm
                                        ? AppTokens.primarySurfaceLight
                                        : AppTokens.infoSurfaceLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    h.assignmentType.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isPerm
                                          ? AppTokens.primary
                                          : AppTokens.info,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              'Project: ${h.projectName ?? "General"} | Date: ${h.assignedDate.toString().split(' ')[0]}',
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isOverdue
                                    ? AppTokens.criticalSurfaceLight
                                    : AppTokens.primarySurfaceLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                h.status.toUpperCase(),
                                style: TextStyle(
                                  color: isOverdue
                                      ? AppTokens.critical
                                      : AppTokens.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text('Error loading handovers: $err'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading item: $err')),
      ),
    );
  }

  Widget _buildStatTile(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: color,
                    fontSize: 20,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
