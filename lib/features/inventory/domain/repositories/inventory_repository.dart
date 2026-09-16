import '../entities/item_entity.dart';

abstract class InventoryRepository {
  Stream<List<ItemEntity>> watchItems({String? searchQuery, String? categoryId, bool lowStockOnly = false});
  Future<ItemEntity?> getItemById(String id);
  Future<void> addItem(ItemEntity item, {int initialQuantity = 10});
  Future<void> updateItem(ItemEntity item);
  Future<void> adjustStock(String itemId, String warehouseId, int deltaQuantity, String movementType, String? notes);
}
