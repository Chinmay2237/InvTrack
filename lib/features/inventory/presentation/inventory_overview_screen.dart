import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/breakpoints.dart';
import '../domain/entities/item_entity.dart';
import 'providers/inventory_provider.dart';

class InventoryOverviewScreen extends ConsumerStatefulWidget {
  const InventoryOverviewScreen({super.key});

  @override
  ConsumerState<InventoryOverviewScreen> createState() =>
      _InventoryOverviewScreenState();
}

class _InventoryOverviewScreenState
    extends ConsumerState<InventoryOverviewScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(itemsStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final filter = ref.watch(inventoryFilterProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(AppIcons.asset, color: AppTokens.primary, size: 22),
            SizedBox(width: 8),
            Text('Inventory Catalog'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.exportCsv),
            tooltip: 'Export CSV',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Exported Inventory catalog to CSV')),
              );
            },
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => context.go('/inventory/new'),
            icon: const Icon(AppIcons.add, size: 18),
            label: const Text('Add Item'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Filter & Search Header Row
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search items by name, SKU, or barcode...',
                          prefixIcon: const Icon(AppIcons.search, size: 18),
                          suffixIcon: filter.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(AppIcons.close, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref
                                        .read(inventoryFilterProvider.notifier)
                                        .state = filter.copyWith(searchQuery: '');
                                  },
                                )
                              : null,
                        ),
                        onChanged: (val) {
                          ref.read(inventoryFilterProvider.notifier).state =
                              filter.copyWith(searchQuery: val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilterChip(
                      label: const Text('Low Stock Only'),
                      selected: filter.lowStockOnly,
                      onSelected: (val) {
                        ref.read(inventoryFilterProvider.notifier).state =
                            filter.copyWith(lowStockOnly: val);
                      },
                      avatar: const Icon(AppIcons.lowStock,
                          size: 14, color: AppTokens.warning),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Category Chips Row
                categoriesAsync.when(
                  data: (categories) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: const Text('All Categories'),
                            selected: filter.categoryId == null,
                            onSelected: (_) {
                              ref.read(inventoryFilterProvider.notifier).state =
                                  InventoryFilterState(
                                searchQuery: filter.searchQuery,
                                lowStockOnly: filter.lowStockOnly,
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          ...categories.map((cat) {
                            final isSelected = filter.categoryId == cat.id;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(cat.name),
                                selected: isSelected,
                                onSelected: (val) {
                                  ref
                                      .read(inventoryFilterProvider.notifier)
                                      .state = filter.copyWith(
                                    categoryId: val ? cat.id : null,
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox(height: 32),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppTokens.borderLight),

          // Items Content View
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(AppIcons.asset,
                            size: 56, color: AppTokens.textDisabledLight),
                        const SizedBox(height: 16),
                        Text(
                          'No inventory items found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try resetting your filters or add a new item to catalog.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => context.go('/inventory/new'),
                          icon: const Icon(AppIcons.add, size: 18),
                          label: const Text('Create First Item'),
                        ),
                      ],
                    ),
                  );
                }

                // Adaptive Layout Rendering
                if (context.isCompact) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildItemCard(context, item);
                    },
                  );
                } else {
                  return _buildDataTable(context, items);
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Error loading inventory: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, ItemEntity item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTokens.primarySurfaceLight,
            borderRadius: BorderRadius.circular(AppTokens.radiusButton),
          ),
          child: item.imageUrl != null && item.imageUrl!.startsWith('assets/')
              ? Image.asset(item.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(AppIcons.asset, color: AppTokens.primary))
              : const Icon(AppIcons.asset, color: AppTokens.primary),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '\$${item.salePrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: AppTokens.primary,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.sku,
                  style: const TextStyle(
                      fontSize: 10,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 8),
              if (item.barcode != null)
                Text(
                  'Barcode: ${item.barcode}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 11),
                ),
            ],
          ),
        ),
        trailing: const Icon(AppIcons.forward, size: 18),
        onTap: () => context.go('/inventory/${item.id}'),
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, List<ItemEntity> items) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: SizedBox(
          width: double.infinity,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              isDark ? AppTokens.surfaceAltDark : AppTokens.surfaceAltLight,
            ),
            columns: const [
              DataColumn(label: Text('ITEM NAME')),
              DataColumn(label: Text('SKU')),
              DataColumn(label: Text('BARCODE')),
              DataColumn(label: Text('COST PRICE')),
              DataColumn(label: Text('SALE PRICE')),
              DataColumn(label: Text('UOM')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: items.map((item) {
              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: AppTokens.primarySurfaceLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(AppIcons.asset,
                              size: 18, color: AppTokens.primary),
                        ),
                        Text(item.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  DataCell(Text(item.sku)),
                  DataCell(Text(item.barcode ?? '—')),
                  DataCell(Text('\$${item.costPrice.toStringAsFixed(2)}')),
                  DataCell(
                    Text(
                      '\$${item.salePrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTokens.primary),
                    ),
                  ),
                  DataCell(Text(item.unitOfMeasure.toUpperCase())),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(AppIcons.search, size: 18),
                          tooltip: 'View Details',
                          onPressed: () => context.go('/inventory/${item.id}'),
                        ),
                        IconButton(
                          icon: const Icon(AppIcons.edit, size: 18),
                          tooltip: 'Edit Item',
                          onPressed: () =>
                              context.go('/inventory/${item.id}/edit'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
