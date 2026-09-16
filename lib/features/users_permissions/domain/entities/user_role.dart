enum UserRole {
  admin('System Admin', 'Full access to catalog, stock, POs, handovers, and settings'),
  manager('Warehouse Manager', 'Manage catalog, stock transfers, handovers, and orders'),
  scannerOnly('Scanner Operator', 'Perform fast barcode scanning and cycle counting only');

  final String label;
  final String description;

  const UserRole(this.label, this.description);

  bool get canEditCatalog => this == UserRole.admin || this == UserRole.manager;
  bool get canManageHandovers => this == UserRole.admin || this == UserRole.manager;
  bool get canAccessSettings => this == UserRole.admin;
}
