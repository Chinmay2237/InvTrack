import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../domain/entities/sales_order_entity.dart';
import '../../domain/repositories/sales_order_repository.dart';

class SalesOrderRepositoryImpl implements SalesOrderRepository {
  final AppDatabase db;

  SalesOrderRepositoryImpl(this.db);

  @override
  Stream<List<SalesOrderEntity>> watchSalesOrders() {
    return db.select(db.salesOrders).watch().asyncMap((orders) async {
      final orderEntities = <SalesOrderEntity>[];
      for (final o in orders) {
        final items = await (db.select(db.salesOrderItems)..where((t) => t.orderId.equals(o.id))).get();
        final itemEntities = items
            .map((i) => SalesOrderItemEntity(
                  id: i.id,
                  orderId: i.orderId,
                  itemId: i.itemId,
                  quantity: i.quantity,
                  unitPrice: i.unitPrice,
                ))
            .toList();

        orderEntities.add(
          SalesOrderEntity(
            id: o.id,
            orderNumber: o.orderNumber,
            customerName: o.customerName,
            status: o.status,
            totalAmount: o.totalAmount,
            createdAt: o.createdAt,
            items: itemEntities,
          ),
        );
      }
      return orderEntities;
    });
  }

  @override
  Future<void> createSalesOrder(SalesOrderEntity order, String warehouseId) async {
    await db.into(db.salesOrders).insert(
          SalesOrdersCompanion.insert(
            id: order.id,
            orderNumber: order.orderNumber,
            customerName: Value(order.customerName),
            status: Value(order.status),
            totalAmount: Value(order.totalAmount),
            createdAt: Value(order.createdAt),
          ),
        );

    for (final item in order.items) {
      await db.into(db.salesOrderItems).insert(
            SalesOrderItemsCompanion.insert(
              id: item.id,
              orderId: order.id,
              itemId: item.itemId,
              quantity: item.quantity,
              unitPrice: item.unitPrice,
            ),
          );

      final currentStock = await (db.select(db.stockLevels)
            ..where((t) => t.itemId.equals(item.itemId) & t.warehouseId.equals(warehouseId)))
          .getSingleOrNull();

      final currentQty = currentStock?.quantity ?? 0;
      final newQty = currentQty - item.quantity;

      await db.into(db.stockLevels).insertOnConflictUpdate(
            StockLevelsCompanion.insert(
              itemId: item.itemId,
              warehouseId: warehouseId,
              quantity: Value(newQty < 0 ? 0 : newQty),
            ),
          );

      await db.into(db.stockMovements).insert(
            StockMovementsCompanion.insert(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              itemId: item.itemId,
              sourceWarehouseId: Value(warehouseId),
              movementType: 'out',
              quantity: item.quantity,
              referenceType: const Value('so'),
              referenceId: Value(order.id),
              notes: Value('Outbound Sales Order #${order.orderNumber}'),
            ),
          );
    }
  }
}
