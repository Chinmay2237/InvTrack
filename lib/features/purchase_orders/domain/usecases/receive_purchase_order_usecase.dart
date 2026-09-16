import '../repositories/purchase_order_repository.dart';

class ReceivePurchaseOrderUseCase {
  final PurchaseOrderRepository repository;

  ReceivePurchaseOrderUseCase(this.repository);

  Future<void> execute(String poId, String warehouseId) async {
    await repository.receivePurchaseOrder(poId, warehouseId);
  }
}
