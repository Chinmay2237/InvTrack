import '../entities/sales_order_entity.dart';

abstract class SalesOrderRepository {
  Stream<List<SalesOrderEntity>> watchSalesOrders();
  Future<void> createSalesOrder(SalesOrderEntity order, String warehouseId);
}
