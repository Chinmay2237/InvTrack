import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database.dart';
import '../../../core/theme/tokens.dart';
import '../../inventory/domain/entities/item_entity.dart';
import '../../inventory/presentation/providers/inventory_provider.dart';
import 'providers/handover_provider.dart';

class HandoversOverviewScreen extends ConsumerStatefulWidget {
  const HandoversOverviewScreen({super.key});

  @override
  ConsumerState<HandoversOverviewScreen> createState() => _HandoversOverviewScreenState();
}

class _HandoversOverviewScreenState extends ConsumerState<HandoversOverviewScreen> {
  String _selectedFilter = 'all'; // 'all', 'permanent', 'temporary', 'returned'

  @override
  Widget build(BuildContext context) {
    final handoversAsync = ref.watch(handoversListProvider);
    final itemsAsync = ref.watch(itemsStreamProvider);
    final employeesAsync = ref.watch(employeesListProvider);

    final itemsMap = itemsAsync.maybeWhen(
      data: (items) => {for (var i in items) i.id: i},
      orElse: () => <String, ItemEntity>{},
    );

    final employeesMap = employeesAsync.maybeWhen(
      data: (emps) => {for (var e in emps) e.id: e},
      orElse: () => <String, Employee>{},
    );

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(LucideIcons.user_check, color: AppTokens.primary, size: 22),
            SizedBox(width: 8),
            Text('Asset Handovers'),
          ],
        ),
        actions: [
          OutlinedButton.icon(
            onPressed: () => context.go('/handovers/queue'),
            icon: const Icon(LucideIcons.clock, size: 16, color: AppTokens.warning),
            label: const Text('Return Queue'),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => context.go('/handovers/new'),
            icon: const Icon(LucideIcons.plus, size: 18),
            label: const Text('New Assignment'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Theme.of(context).brightness == Brightness.dark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Handovers'),
                    selected: _selectedFilter == 'all',
                    onSelected: (_) => setState(() => _selectedFilter = 'all'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Permanent'),
                    selected: _selectedFilter == 'permanent',
                    onSelected: (_) => setState(() => _selectedFilter = 'permanent'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Temporary'),
                    selected: _selectedFilter == 'temporary',
                    onSelected: (_) => setState(() => _selectedFilter = 'temporary'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Returned'),
                    selected: _selectedFilter == 'returned',
                    onSelected: (_) => setState(() => _selectedFilter = 'returned'),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppTokens.borderLight),

          // Main List Content
          Expanded(
            child: handoversAsync.when(
              data: (handovers) {
                final filtered = handovers.where((h) {
                  if (_selectedFilter == 'permanent') return h.assignmentType == 'permanent';
                  if (_selectedFilter == 'temporary') return h.assignmentType == 'temporary' && h.status != 'returned';
                  if (_selectedFilter == 'returned') return h.status == 'returned';
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.user_x, size: 56, color: AppTokens.textSecondaryLight),
                        const SizedBox(height: 16),
                        Text('No handovers matching criteria', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => context.go('/handovers/new'),
                          icon: const Icon(LucideIcons.plus),
                          label: const Text('Assign First Asset'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final h = filtered[index];
                    final item = itemsMap[h.itemId];
                    final emp = employeesMap[h.employeeId];
                    final isPerm = h.assignmentType == 'permanent';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: isPerm ? AppTokens.primarySurfaceLight : AppTokens.infoSurfaceLight,
                          child: Icon(
                            isPerm ? LucideIcons.user_check : LucideIcons.clock,
                            color: isPerm ? AppTokens.primary : AppTokens.info,
                            size: 20,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              item?.name ?? 'Asset ${h.itemId}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isPerm ? AppTokens.primarySurfaceLight : AppTokens.infoSurfaceLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                h.assignmentType.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isPerm ? AppTokens.primary : AppTokens.info,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Assigned to: ${emp?.name ?? h.employeeId} (${emp?.department ?? "Ops"}) | Project: ${h.projectName ?? "General"}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: h.status == 'returned'
                                ? Colors.grey.shade200
                                : (h.status == 'overdue' ? AppTokens.criticalSurfaceLight : AppTokens.primarySurfaceLight),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            h.status.toUpperCase(),
                            style: TextStyle(
                              color: h.status == 'returned'
                                  ? Colors.grey.shade700
                                  : (h.status == 'overdue' ? AppTokens.critical : AppTokens.primary),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error loading handovers: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
