import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:invtrack/features/purchase_orders/domain/repositories/purchase_order_repository.dart';
import 'package:invtrack/features/purchase_orders/domain/usecases/receive_purchase_order_usecase.dart';

class MockPurchaseOrderRepository extends Mock
    implements PurchaseOrderRepository {}

void main() {
  late MockPurchaseOrderRepository mockRepository;
  late ReceivePurchaseOrderUseCase useCase;

  setUp(() {
    mockRepository = MockPurchaseOrderRepository();
    useCase = ReceivePurchaseOrderUseCase(mockRepository);
  });

  test('ReceivePurchaseOrderUseCase delegates call to PurchaseOrderRepository',
      () async {
    when(() => mockRepository.receivePurchaseOrder('po_1', 'wh_main'))
        .thenAnswer((_) async => Future.value());

    await useCase.execute('po_1', 'wh_main');

    verify(() => mockRepository.receivePurchaseOrder('po_1', 'wh_main'))
        .called(1);
  });
}
