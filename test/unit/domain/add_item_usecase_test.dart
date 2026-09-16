import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:invtrack/features/inventory/domain/entities/item_entity.dart';
import 'package:invtrack/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:invtrack/features/inventory/domain/usecases/add_item_usecase.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

void main() {
  late MockInventoryRepository mockRepository;
  late AddItemUseCase useCase;

  setUp(() {
    mockRepository = MockInventoryRepository();
    useCase = AddItemUseCase(mockRepository);
  });

  final testItem = ItemEntity(
    id: 'test_1',
    sku: 'SKU-001',
    name: 'Test Item',
    salePrice: 99.99,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  test('AddItemUseCase delegates addItem call to InventoryRepository', () async {
    when(() => mockRepository.addItem(testItem, initialQuantity: 10))
        .thenAnswer((_) async => Future.value());

    await useCase.execute(testItem, initialQuantity: 10);

    verify(() => mockRepository.addItem(testItem, initialQuantity: 10)).called(1);
  });
}
