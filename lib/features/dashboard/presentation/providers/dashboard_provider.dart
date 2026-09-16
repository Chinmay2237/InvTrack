import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../../../core/database/database_provider.dart';

class DashboardKpis {
  final double totalStockValue;
  final int totalItemsCount;
  final int lowStockCount;
  final int assignedAssetsCount;
  final int totalMovementsCount;

  DashboardKpis({
    required this.totalStockValue,
    required this.totalItemsCount,
    required this.lowStockCount,
    required this.assignedAssetsCount,
    required this.totalMovementsCount,
  });
}

final dashboardKpisProvider = StreamProvider<DashboardKpis>((ref) async* {
  final db = ref.watch(databaseProvider);

  yield* db.select(db.items).watch().asyncMap((items) async {
    final stockLevels = await db.select(db.stockLevels).get();
    final handovers = await db.select(db.handovers).get();
    final movements = await db.select(db.stockMovements).get();

    double totalVal = 0.0;
    int lowStock = 0;

    for (final item in items) {
      final itemStocks = stockLevels.where((s) => s.itemId == item.id);
      final itemQty = itemStocks.fold<int>(0, (sum, s) => sum + s.quantity);
      totalVal += itemQty * item.salePrice;

      if (itemQty <= item.reorderPoint) {
        lowStock++;
      }
    }

    final activeHandovers =
        handovers.where((h) => h.status != 'returned').length;

    return DashboardKpis(
      totalStockValue: totalVal,
      totalItemsCount: items.length,
      lowStockCount: lowStock,
      assignedAssetsCount: activeHandovers,
      totalMovementsCount: movements.length,
    );
  });
});

final recentMovementsProvider = StreamProvider<List<StockMovement>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.stockMovements)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ])
        ..limit(5))
      .watch();
});
