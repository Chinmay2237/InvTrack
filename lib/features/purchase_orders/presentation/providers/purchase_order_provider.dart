import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/repositories/purchase_order_repository_impl.dart';
import '../../domain/entities/purchase_order_entity.dart';
import '../../domain/repositories/purchase_order_repository.dart';
import '../../domain/usecases/create_purchase_order_usecase.dart';
import '../../domain/usecases/receive_purchase_order_usecase.dart';

final purchaseOrderRepositoryProvider =
    Provider<PurchaseOrderRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return PurchaseOrderRepositoryImpl(db);
});

final createPurchaseOrderUseCaseProvider =
    Provider<CreatePurchaseOrderUseCase>((ref) {
  final repo = ref.watch(purchaseOrderRepositoryProvider);
  return CreatePurchaseOrderUseCase(repo);
});

final receivePurchaseOrderUseCaseProvider =
    Provider<ReceivePurchaseOrderUseCase>((ref) {
  final repo = ref.watch(purchaseOrderRepositoryProvider);
  return ReceivePurchaseOrderUseCase(repo);
});

final purchaseOrdersListProvider =
    StreamProvider<List<PurchaseOrderEntity>>((ref) {
  final repo = ref.watch(purchaseOrderRepositoryProvider);
  return repo.watchPurchaseOrders();
});
