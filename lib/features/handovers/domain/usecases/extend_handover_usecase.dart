import '../repositories/handover_repository.dart';

class ExtendHandoverUseCase {
  final HandoverRepository repository;

  ExtendHandoverUseCase(this.repository);

  Future<void> execute(String handoverId, DateTime newDueDate) async {
    await repository.extendDueDate(handoverId, newDueDate);
  }
}
