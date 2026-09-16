import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/usecases/add_item_usecase.dart';
import '../../domain/usecases/get_items_usecase.dart';
import '../../../../core/database/database.dart';

class InventoryFilterState {
  final String searchQuery;
  final String? categoryId;
  final bool lowStockOnly;

  InventoryFilterState({
    this.searchQuery = '',
    this.categoryId,
    this.lowStockOnly = false,
  });

  InventoryFilterState copyWith({
    String? searchQuery,
    String? categoryId,
    bool? lowStockOnly,
  }) {
    return InventoryFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: categoryId,
      lowStockOnly: lowStockOnly ?? this.lowStockOnly,
    );
  }
}

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return InventoryRepositoryImpl(db);
});

final getItemsUseCaseProvider = Provider<GetItemsUseCase>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return GetItemsUseCase(repo);
});

final addItemUseCaseProvider = Provider<AddItemUseCase>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return AddItemUseCase(repo);
});

final inventoryFilterProvider = StateProvider<InventoryFilterState>((ref) {
  return InventoryFilterState();
});

final itemsStreamProvider = StreamProvider<List<ItemEntity>>((ref) {
  final useCase = ref.watch(getItemsUseCaseProvider);
  final filter = ref.watch(inventoryFilterProvider);

  return useCase.execute(
    searchQuery: filter.searchQuery,
    categoryId: filter.categoryId,
    lowStockOnly: filter.lowStockOnly,
  );
});

final itemDetailProvider = StreamProvider.family<ItemEntity?, String>((ref, itemId) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return Stream.fromFuture(repo.getItemById(itemId));
});

final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.categories).watch();
});
