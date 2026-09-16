import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../domain/entities/handover_entity.dart';
import '../../domain/repositories/handover_repository.dart';

class HandoverRepositoryImpl implements HandoverRepository {
  final AppDatabase db;

  HandoverRepositoryImpl(this.db);

  HandoverEntity _mapToEntity(Handover h) {
    return HandoverEntity(
      id: h.id,
      itemId: h.itemId,
      employeeId: h.employeeId,
      assignmentType: h.assignmentType,
      projectName: h.projectName,
      assignedDate: h.assignedDate,
      dueDate: h.dueDate,
      returnDate: h.returnDate,
      status: h.status,
      notes: h.notes,
    );
  }

  @override
  Stream<List<HandoverEntity>> watchHandovers() {
    return db
        .select(db.handovers)
        .watch()
        .map((rows) => rows.map(_mapToEntity).toList());
  }

  @override
  Stream<List<HandoverEntity>> watchActiveTemporaryHandovers() {
    final query = db.select(db.handovers)
      ..where((t) =>
          t.assignmentType.equals('temporary') &
          (t.status.equals('active') | t.status.equals('overdue')));
    return query.watch().map((rows) => rows.map(_mapToEntity).toList());
  }

  @override
  Future<void> createHandover(HandoverEntity handover) async {
    await db.into(db.handovers).insert(
          HandoversCompanion.insert(
            id: handover.id,
            itemId: handover.itemId,
            employeeId: handover.employeeId,
            assignmentType: handover.assignmentType,
            projectName: Value(handover.projectName),
            assignedDate: Value(handover.assignedDate),
            dueDate: Value(handover.dueDate),
            status: Value(handover.status),
            notes: Value(handover.notes),
          ),
        );

    await db.into(db.handoverLogs).insert(
          HandoverLogsCompanion.insert(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            handoverId: handover.id,
            action: 'assigned',
            timestamp: Value(handover.assignedDate),
            notes: Value('Assigned ${handover.assignmentType} handover'),
          ),
        );
  }

  @override
  Future<void> returnAsset(String handoverId, DateTime returnDate,
      {String? notes}) async {
    await (db.update(db.handovers)..where((t) => t.id.equals(handoverId)))
        .write(
      HandoversCompanion(
        status: const Value('returned'),
        returnDate: Value(returnDate),
      ),
    );

    await db.into(db.handoverLogs).insert(
          HandoverLogsCompanion.insert(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            handoverId: handoverId,
            action: 'returned',
            timestamp: Value(returnDate),
            notes: Value(notes ?? 'Asset returned safely'),
          ),
        );
  }

  @override
  Future<void> extendDueDate(String handoverId, DateTime newDueDate) async {
    await (db.update(db.handovers)..where((t) => t.id.equals(handoverId)))
        .write(
      HandoversCompanion(
        dueDate: Value(newDueDate),
        status: const Value('active'),
      ),
    );

    await db.into(db.handoverLogs).insert(
          HandoverLogsCompanion.insert(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            handoverId: handoverId,
            action: 'extended',
            timestamp: Value(DateTime.now()),
            notes: Value(
                'Extended due date to ${newDueDate.toString().split(' ')[0]}'),
          ),
        );
  }
}
