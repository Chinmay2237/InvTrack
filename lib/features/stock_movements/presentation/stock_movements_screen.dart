import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/tokens.dart';
import '../../inventory/domain/entities/item_entity.dart';
import '../../inventory/presentation/providers/inventory_provider.dart';

final allStockMovementsProvider = StreamProvider<List<StockMovement>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.stockMovements)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ]))
      .watch();
});

class StockMovementsScreen extends ConsumerWidget {
  const StockMovementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movementsAsync = ref.watch(allStockMovementsProvider);
    final itemsAsync = ref.watch(itemsStreamProvider);

    final itemsMap = itemsAsync.maybeWhen(
      data: (items) => {for (var i in items) i.id: i},
      orElse: () => <String, ItemEntity>{},
    );

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(AppIcons.handovers, color: AppTokens.primary, size: 22),
            SizedBox(width: 8),
            Text('Stock Movement Ledger'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: movementsAsync.when(
        data: (movements) {
          if (movements.isEmpty) {
            return const Center(
                child: Text('No stock movements recorded yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: movements.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final m = movements[index];
              final item = itemsMap[m.itemId];
              final isIn = m.movementType == 'in';

              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: CircleAvatar(
                    backgroundColor: isIn
                        ? AppTokens.primarySurfaceLight
                        : AppTokens.criticalSurfaceLight,
                    child: Icon(
                      isIn ? AppIcons.back : AppIcons.forward,
                      color: isIn ? AppTokens.primary : AppTokens.critical,
                      size: 20,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(item?.name ?? 'Item ${m.itemId}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isIn
                              ? AppTokens.primarySurfaceLight
                              : AppTokens.criticalSurfaceLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          m.movementType.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color:
                                isIn ? AppTokens.primary : AppTokens.critical,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${m.notes ?? "Movement record"} | ${m.createdAt.toString().split('.')[0]}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  trailing: Text(
                    '${isIn ? "+" : "-"}${m.quantity} ${item?.unitOfMeasure ?? "units"}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isIn ? AppTokens.primary : AppTokens.critical,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading ledger: $err')),
      ),
    );
  }
}
