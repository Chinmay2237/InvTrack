class AssignedItem {
  final String id;
  final String productId;
  final String employeeId;
  final DateTime assignedDate;
  final int quantity;

  AssignedItem({
    required this.id,
    required this.productId,
    required this.employeeId,
    required this.assignedDate,
    required this.quantity,
  });
}
