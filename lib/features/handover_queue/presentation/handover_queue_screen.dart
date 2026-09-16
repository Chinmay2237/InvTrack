import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/breakpoints.dart';
import '../../handovers/presentation/providers/handover_provider.dart';
import '../../inventory/domain/entities/item_entity.dart';
import '../../inventory/presentation/providers/inventory_provider.dart';

import '../../handovers/domain/entities/handover_entity.dart';

class HandoverQueueScreen extends ConsumerWidget {
  const HandoverQueueScreen({super.key});

  Future<void> _markReturned(BuildContext context, WidgetRef ref, HandoverEntity handover) async {
    final now = DateTime.now();

    await ref.read(returnAssetUseCaseProvider).execute(
          handover.id,
          now,
          notes: 'Asset returned safely via Handover Queue',
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asset marked as returned')),
      );
    }
  }

  Future<void> _extendDueDate(BuildContext context, WidgetRef ref, HandoverEntity handover) async {
    final newDueDate = (handover.dueDate ?? DateTime.now()).add(const Duration(days: 7));

    await ref.read(extendHandoverUseCaseProvider).execute(handover.id, newDueDate);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Extended due date to ${newDueDate.toString().split(' ')[0]}')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAsync = ref.watch(activeTemporaryHandoversProvider);
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
            Icon(LucideIcons.clock, color: AppTokens.warning, size: 22),
            SizedBox(width: 8),
            Text('Pending Return Queue'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left),
          onPressed: () => context.go('/handovers'),
        ),
      ),
      body: queueAsync.when(
        data: (queue) {
          if (queue.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.circle_check, size: 64, color: AppTokens.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Queue Clear!',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'All temporary handovers are currently returned and up to date.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: queue.length,
            itemBuilder: (context, index) {
              final h = queue[index];
              final item = itemsMap[h.itemId];
              final emp = employeesMap[h.employeeId];
              final isOverdue = h.dueDate != null && h.dueDate!.isBefore(DateTime.now());

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isOverdue ? AppTokens.criticalSurfaceLight : AppTokens.warningSurfaceLight,
                          borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                        ),
                        child: Icon(
                          isOverdue ? LucideIcons.triangle_alert : LucideIcons.clock,
                          color: isOverdue ? AppTokens.critical : AppTokens.warning,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item?.name ?? 'Asset ${h.itemId}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isOverdue ? AppTokens.criticalSurfaceLight : AppTokens.warningSurfaceLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    isOverdue ? 'OVERDUE' : 'DUE SOON',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isOverdue ? AppTokens.critical : AppTokens.warning,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Assigned to: ${emp?.name ?? h.employeeId} (${emp?.department ?? "Ops"})',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Project: ${h.projectName ?? "N/A"} | Due: ${h.dueDate?.toString().split(' ')[0] ?? "Flexible"}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _extendDueDate(context, ref, h),
                            icon: const Icon(LucideIcons.calendar_plus, size: 16),
                            label: Text(context.isCompact ? '+7d' : 'Extend'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _markReturned(context, ref, h),
                            style: ElevatedButton.styleFrom(backgroundColor: AppTokens.primary),
                            icon: const Icon(LucideIcons.circle_check, size: 16),
                            label: Text(context.isCompact ? 'Return' : 'Mark Returned'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading queue: $err')),
      ),
    );
  }
}
