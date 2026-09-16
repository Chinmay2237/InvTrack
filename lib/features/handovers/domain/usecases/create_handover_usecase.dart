import '../entities/handover_entity.dart';
import '../repositories/handover_repository.dart';

class CreateHandoverUseCase {
  final HandoverRepository repository;

  CreateHandoverUseCase(this.repository);

  Future<void> execute(HandoverEntity handover) async {
    await repository.createHandover(handover);
  }
}
