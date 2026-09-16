import '../entities/handover_entity.dart';

abstract class HandoverRepository {
  Stream<List<HandoverEntity>> watchHandovers();
  Stream<List<HandoverEntity>> watchActiveTemporaryHandovers();
  Future<void> createHandover(HandoverEntity handover);
  Future<void> returnAsset(String handoverId, DateTime returnDate, {String? notes});
  Future<void> extendDueDate(String handoverId, DateTime newDueDate);
}
