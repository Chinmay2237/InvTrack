import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final AppDatabase db;

  InventoryRepositoryImpl(this.db);

  ItemEntity _mapToEntity(Item item) {
    return ItemEntity(
      id: item.id,
      sku: item.sku,
      name: item.name,
      description: item.description,
      barcode: item.barcode,
      categoryId: item.categoryId,
      costPrice: item.costPrice,
      salePrice: item.salePrice,
      taxRate: item.taxRate,
      unitOfMeasure: item.unitOfMeasure,
      reorderPoint: item.reorderPoint,
      imageUrl: item.imageUrl,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }

  @override
  Stream<List<ItemEntity>> watchItems({String? searchQuery, String? categoryId, bool lowStockOnly = false}) {
    var query = db.select(db.items);

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final search = '%${searchQuery.trim()}%';
      query.where((t) => t.name.like(search) | t.sku.like(search) | t.barcode.like(search));
    }

    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }

    return query.watch().map((rows) => rows.map(_mapToEntity).toList());
  }

  @override
  Future<ItemEntity?> getItemById(String id) async {
    final row = await (db.select(db.items)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _mapToEntity(row) : null;
  }

  @override
  Future<void> addItem(ItemEntity item, {int initialQuantity = 10}) async {
    await db.into(db.items).insert(
          ItemsCompanion.insert(
            id: item.id,
            sku: item.sku,
            name: item.name,
            description: Value(item.description),
            barcode: Value(item.barcode),
            categoryId: Value(item.categoryId),
            costPrice: Value(item.costPrice),
            salePrice: Value(item.salePrice),
            taxRate: Value(item.taxRate),
            unitOfMeasure: Value(item.unitOfMeasure),
            reorderPoint: Value(item.reorderPoint),
            imageUrl: Value(item.imageUrl),
            createdAt: Value(item.createdAt),
            updatedAt: Value(item.updatedAt),
          ),
        );

    final mainWh = (await db.select(db.warehouses).get()).firstOrNull;
    if (mainWh != null) {
      await db.into(db.stockLevels).insert(
            StockLevelsCompanion.insert(
              itemId: item.id,
              warehouseId: mainWh.id,
              quantity: Value(initialQuantity),
            ),
          );
    }
  }

  @override
  Future<void> updateItem(ItemEntity item) async {
    await (db.update(db.items)..where((t) => t.id.equals(item.id))).write(
      ItemsCompanion(
        name: Value(item.name),
        sku: Value(item.sku),
        barcode: Value(item.barcode),
        categoryId: Value(item.categoryId),
        costPrice: Value(item.costPrice),
        salePrice: Value(item.salePrice),
        taxRate: Value(item.taxRate),
        unitOfMeasure: Value(item.unitOfMeasure),
        reorderPoint: Value(item.reorderPoint),
        imageUrl: Value(item.imageUrl),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> adjustStock(String itemId, String warehouseId, int deltaQuantity, String movementType, String? notes) async {
    final currentStock = await (db.select(db.stockLevels)
          ..where((t) => t.itemId.equals(itemId) & t.warehouseId.equals(warehouseId)))
        .getSingleOrNull();

    final currentQty = currentStock?.quantity ?? 0;
    final newQty = movementType == 'in' ? currentQty + deltaQuantity : currentQty - deltaQuantity;

    await db.into(db.stockLevels).insertOnConflictUpdate(
          StockLevelsCompanion.insert(
            itemId: itemId,
            warehouseId: warehouseId,
            quantity: Value(newQty < 0 ? 0 : newQty),
          ),
        );

    await db.into(db.stockMovements).insert(
          StockMovementsCompanion.insert(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            itemId: itemId,
            targetWarehouseId: Value(warehouseId),
            movementType: movementType,
            quantity: deltaQuantity,
            notes: Value(notes),
          ),
        );
  }
}
