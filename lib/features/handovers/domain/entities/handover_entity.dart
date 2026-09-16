class HandoverEntity {
  final String id;
  final String itemId;
  final String employeeId;
  final String assignmentType; // 'permanent', 'temporary'
  final String? projectName;
  final DateTime assignedDate;
  final DateTime? dueDate;
  final DateTime? returnDate;
  final String status; // 'active', 'returned', 'overdue'
  final String? notes;

  const HandoverEntity({
    required this.id,
    required this.itemId,
    required this.employeeId,
    required this.assignmentType,
    this.projectName,
    required this.assignedDate,
    this.dueDate,
    this.returnDate,
    this.status = 'active',
    this.notes,
  });
}
