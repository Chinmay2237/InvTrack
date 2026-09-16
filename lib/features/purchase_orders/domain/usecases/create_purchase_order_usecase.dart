import '../entities/purchase_order_entity.dart';
import '../repositories/purchase_order_repository.dart';

class CreatePurchaseOrderUseCase {
  final PurchaseOrderRepository repository;

  CreatePurchaseOrderUseCase(this.repository);

  Future<void> execute(PurchaseOrderEntity po) async {
    await repository.createPurchaseOrder(po);
  }
}
