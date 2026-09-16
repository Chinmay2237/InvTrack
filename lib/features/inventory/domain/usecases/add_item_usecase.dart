import '../entities/item_entity.dart';
import '../repositories/inventory_repository.dart';

class AddItemUseCase {
  final InventoryRepository repository;

  AddItemUseCase(this.repository);

  Future<void> execute(ItemEntity item, {int initialQuantity = 10}) async {
    await repository.addItem(item, initialQuantity: initialQuantity);
  }
}
