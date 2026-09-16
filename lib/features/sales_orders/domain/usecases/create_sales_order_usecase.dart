import '../entities/sales_order_entity.dart';
import '../repositories/sales_order_repository.dart';

class CreateSalesOrderUseCase {
  final SalesOrderRepository repository;

  CreateSalesOrderUseCase(this.repository);

  Future<void> execute(SalesOrderEntity order, String warehouseId) async {
    await repository.createSalesOrder(order, warehouseId);
  }
}
