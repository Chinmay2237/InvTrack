import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/repositories/handover_repository_impl.dart';
import '../../domain/entities/handover_entity.dart';
import '../../domain/repositories/handover_repository.dart';
import '../../domain/usecases/create_handover_usecase.dart';
import '../../domain/usecases/extend_handover_usecase.dart';
import '../../domain/usecases/return_asset_usecase.dart';

final handoverRepositoryProvider = Provider<HandoverRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return HandoverRepositoryImpl(db);
});

final createHandoverUseCaseProvider = Provider<CreateHandoverUseCase>((ref) {
  final repo = ref.watch(handoverRepositoryProvider);
  return CreateHandoverUseCase(repo);
});

final returnAssetUseCaseProvider = Provider<ReturnAssetUseCase>((ref) {
  final repo = ref.watch(handoverRepositoryProvider);
  return ReturnAssetUseCase(repo);
});

final extendHandoverUseCaseProvider = Provider<ExtendHandoverUseCase>((ref) {
  final repo = ref.watch(handoverRepositoryProvider);
  return ExtendHandoverUseCase(repo);
});

final handoversListProvider = StreamProvider<List<HandoverEntity>>((ref) {
  final repo = ref.watch(handoverRepositoryProvider);
  return repo.watchHandovers();
});

final activeTemporaryHandoversProvider = StreamProvider<List<HandoverEntity>>((ref) {
  final repo = ref.watch(handoverRepositoryProvider);
  return repo.watchActiveTemporaryHandovers();
});

final employeesListProvider = StreamProvider<List<Employee>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.employees).watch();
});
