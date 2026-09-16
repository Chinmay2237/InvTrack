import '../repositories/handover_repository.dart';

class ReturnAssetUseCase {
  final HandoverRepository repository;

  ReturnAssetUseCase(this.repository);

  Future<void> execute(String handoverId, DateTime returnDate, {String? notes}) async {
    await repository.returnAsset(handoverId, returnDate, notes: notes);
  }
}
