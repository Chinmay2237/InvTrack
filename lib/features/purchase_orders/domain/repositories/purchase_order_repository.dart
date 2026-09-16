import '../entities/purchase_order_entity.dart';

abstract class PurchaseOrderRepository {
  Stream<List<PurchaseOrderEntity>> watchPurchaseOrders();
  Future<void> createPurchaseOrder(PurchaseOrderEntity po);
  Future<void> receivePurchaseOrder(String poId, String warehouseId);
}
