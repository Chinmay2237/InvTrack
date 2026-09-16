import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../domain/entities/purchase_order_entity.dart';
import '../../domain/repositories/purchase_order_repository.dart';

class PurchaseOrderRepositoryImpl implements PurchaseOrderRepository {
  final AppDatabase db;

  PurchaseOrderRepositoryImpl(this.db);

  @override
  Stream<List<PurchaseOrderEntity>> watchPurchaseOrders() {
    return db.select(db.purchaseOrders).watch().asyncMap((pos) async {
      final poEntities = <PurchaseOrderEntity>[];
      for (final po in pos) {
        final items = await (db.select(db.purchaseOrderItems)
              ..where((t) => t.poId.equals(po.id)))
            .get();
        final itemEntities = items
            .map((i) => PurchaseOrderItemEntity(
                  id: i.id,
                  poId: i.poId,
                  itemId: i.itemId,
                  orderedQty: i.orderedQty,
                  receivedQty: i.receivedQty,
                  unitCost: i.unitCost,
                ))
            .toList();

        poEntities.add(
          PurchaseOrderEntity(
            id: po.id,
            poNumber: po.poNumber,
            supplierId: po.supplierId,
            status: po.status,
            createdAt: po.createdAt,
            expectedDate: po.expectedDate,
            items: itemEntities,
          ),
        );
      }
      return poEntities;
    });
  }

  @override
  Future<void> createPurchaseOrder(PurchaseOrderEntity po) async {
    await db.into(db.purchaseOrders).insert(
          PurchaseOrdersCompanion.insert(
            id: po.id,
            poNumber: po.poNumber,
            supplierId: po.supplierId,
            status: Value(po.status),
            createdAt: Value(po.createdAt),
            expectedDate: Value(po.expectedDate),
          ),
        );

    for (final item in po.items) {
      await db.into(db.purchaseOrderItems).insert(
            PurchaseOrderItemsCompanion.insert(
              id: item.id,
              poId: po.id,
              itemId: item.itemId,
              orderedQty: item.orderedQty,
              receivedQty: Value(item.receivedQty),
              unitCost: item.unitCost,
            ),
          );
    }
  }

  @override
  Future<void> receivePurchaseOrder(String poId, String warehouseId) async {
    await (db.update(db.purchaseOrders)..where((t) => t.id.equals(poId))).write(
      const PurchaseOrdersCompanion(
        status: Value('received'),
      ),
    );

    final items = await (db.select(db.purchaseOrderItems)
          ..where((t) => t.poId.equals(poId)))
        .get();

    for (final item in items) {
      await (db.update(db.purchaseOrderItems)
            ..where((t) => t.id.equals(item.id)))
          .write(
        PurchaseOrderItemsCompanion(
          receivedQty: Value(item.orderedQty),
        ),
      );

      final currentStock = await (db.select(db.stockLevels)
            ..where((t) =>
                t.itemId.equals(item.itemId) &
                t.warehouseId.equals(warehouseId)))
          .getSingleOrNull();

      final currentQty = currentStock?.quantity ?? 0;
      final newQty = currentQty + item.orderedQty;

      await db.into(db.stockLevels).insertOnConflictUpdate(
            StockLevelsCompanion.insert(
              itemId: item.itemId,
              warehouseId: warehouseId,
              quantity: Value(newQty),
            ),
          );

      await db.into(db.stockMovements).insert(
            StockMovementsCompanion.insert(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              itemId: item.itemId,
              targetWarehouseId: Value(warehouseId),
              movementType: 'in',
              quantity: item.orderedQty,
              referenceType: const Value('po'),
              referenceId: Value(poId),
              notes: Value('Received Purchase Order #$poId'),
            ),
          );
    }
  }
}
