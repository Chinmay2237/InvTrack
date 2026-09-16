import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/repositories/sales_order_repository_impl.dart';
import '../../domain/entities/sales_order_entity.dart';
import '../../domain/repositories/sales_order_repository.dart';
import '../../domain/usecases/create_sales_order_usecase.dart';

final salesOrderRepositoryProvider = Provider<SalesOrderRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SalesOrderRepositoryImpl(db);
});

final createSalesOrderUseCaseProvider = Provider<CreateSalesOrderUseCase>((ref) {
  final repo = ref.watch(salesOrderRepositoryProvider);
  return CreateSalesOrderUseCase(repo);
});

final salesOrdersListProvider = StreamProvider<List<SalesOrderEntity>>((ref) {
  final repo = ref.watch(salesOrderRepositoryProvider);
  return repo.watchSalesOrders();
});
