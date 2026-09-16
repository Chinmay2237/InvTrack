import '../entities/item_entity.dart';
import '../repositories/inventory_repository.dart';

class GetItemsUseCase {
  final InventoryRepository repository;

  GetItemsUseCase(this.repository);

  Stream<List<ItemEntity>> execute({String? searchQuery, String? categoryId, bool lowStockOnly = false}) {
    return repository.watchItems(searchQuery: searchQuery, categoryId: categoryId, lowStockOnly: lowStockOnly);
  }
}
