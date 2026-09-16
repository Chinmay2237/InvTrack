import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

// --- Tables ---

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Items extends Table {
  TextColumn get id => text()();
  TextColumn get sku => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  RealColumn get costPrice => real().withDefault(const Constant(0.0))();
  RealColumn get salePrice => real().withDefault(const Constant(0.0))();
  RealColumn get taxRate => real().withDefault(const Constant(0.0))();
  TextColumn get unitOfMeasure => text().withDefault(const Constant('each'))();
  IntColumn get reorderPoint => integer().withDefault(const Constant(5))();
  TextColumn get imageUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Warehouses extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get code => text()();
  TextColumn get address => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class StockLevels extends Table {
  TextColumn get itemId => text()();
  TextColumn get warehouseId => text()();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  IntColumn get reservedQuantity => integer().withDefault(const Constant(0))();
  IntColumn get minQuantity => integer().withDefault(const Constant(5))();

  @override
  Set<Column> get primaryKey => {itemId, warehouseId};
}

class StockMovements extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text()();
  TextColumn get sourceWarehouseId => text().nullable()();
  TextColumn get targetWarehouseId => text().nullable()();
  TextColumn get movementType =>
      text()(); // 'in', 'out', 'transfer', 'adjustment'
  IntColumn get quantity => integer()();
  TextColumn get referenceType =>
      text().nullable()(); // 'po', 'so', 'handover', 'manual'
  TextColumn get referenceId => text().nullable()();
  TextColumn get createdBy => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Employees extends Table {
  TextColumn get id => text()();
  TextColumn get employeeCode => text()();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get department => text().nullable()();
  TextColumn get contactNumber => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Handovers extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text()();
  TextColumn get employeeId => text()();
  TextColumn get assignmentType => text()(); // 'permanent', 'temporary'
  TextColumn get projectName => text().nullable()();
  DateTimeColumn get assignedDate =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get returnDate => dateTime().nullable()();
  TextColumn get status => text().withDefault(
      const Constant('active'))(); // 'active', 'returned', 'overdue'
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class HandoverLogs extends Table {
  TextColumn get id => text()();
  TextColumn get handoverId => text()();
  TextColumn get action => text()(); // 'assigned', 'extended', 'returned'
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Suppliers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get contactPerson => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  IntColumn get leadTimeDays => integer().withDefault(const Constant(7))();

  @override
  Set<Column> get primaryKey => {id};
}

class PurchaseOrders extends Table {
  TextColumn get id => text()();
  TextColumn get poNumber => text()();
  TextColumn get supplierId => text()();
  TextColumn get status => text().withDefault(
      const Constant('draft'))(); // 'draft', 'submitted', 'received'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expectedDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PurchaseOrderItems extends Table {
  TextColumn get id => text()();
  TextColumn get poId => text()();
  TextColumn get itemId => text()();
  IntColumn get orderedQty => integer()();
  IntColumn get receivedQty => integer().withDefault(const Constant(0))();
  RealColumn get unitCost => real()();

  @override
  Set<Column> get primaryKey => {id};
}

class SalesOrders extends Table {
  TextColumn get id => text()();
  TextColumn get orderNumber => text()();
  TextColumn get customerName => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class SalesOrderItems extends Table {
  TextColumn get id => text()();
  TextColumn get orderId => text()();
  TextColumn get itemId => text()();
  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Categories,
  Items,
  Warehouses,
  StockLevels,
  StockMovements,
  Employees,
  Handovers,
  HandoverLogs,
  Suppliers,
  PurchaseOrders,
  PurchaseOrderItems,
  SalesOrders,
  SalesOrderItems,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'invtrack_v2_db');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        await _seedInitialData();
      },
    );
  }

  Future<void> _seedInitialData() async {
    const uuid = Uuid();
    const mainWarehouseId = 'wh_main';
    final now = DateTime.now();

    // 1. Seed Main Warehouse
    await into(warehouses).insert(
      WarehousesCompanion.insert(
        id: mainWarehouseId,
        name: 'Main Logistics Center',
        code: 'WH-MAIN',
        address: const Value('100 Warehouse Way, Tech Park'),
      ),
    );

    // 2. Seed Secondary Warehouse
    await into(warehouses).insert(
      WarehousesCompanion.insert(
        id: 'wh_site_a',
        name: 'Project Site Alpha',
        code: 'WH-SITE-A',
        address: const Value('Building B, North Site'),
      ),
    );

    // 3. Seed Medical Device Categories
    const diagId = 'cat_med_diag';
    const monId = 'cat_med_mon';
    const labId = 'cat_med_lab';
    const surgId = 'cat_med_surg';

    await into(categories).insert(
      CategoriesCompanion.insert(
        id: diagId,
        name: 'Diagnostic Systems',
        description:
            const Value('Ultrasound, optical scanners & lab diagnostics'),
      ),
    );
    await into(categories).insert(
      CategoriesCompanion.insert(
        id: monId,
        name: 'Patient Monitoring',
        description: const Value('ECG, telemetry & multi-parameter monitors'),
      ),
    );
    await into(categories).insert(
      CategoriesCompanion.insert(
        id: labId,
        name: 'Laboratory Equipment',
        description: const Value('Pipette stations, centrifuges & analyzers'),
      ),
    );
    await into(categories).insert(
      CategoriesCompanion.insert(
        id: surgId,
        name: 'Surgical & Clinical Equipment',
        description:
            const Value('Sterile consoles, peripherals & kit packages'),
      ),
    );

    // 4. Seed Clinical & Biomedical Staff
    const emp1 = 'E1';
    const emp2 = 'E2';
    const emp3 = 'E3';
    const emp4 = 'E4';

    await into(employees).insert(EmployeesCompanion.insert(
        id: emp1,
        employeeCode: 'EMP-001',
        name: 'Dr. Sarah Jenkins',
        email: const Value('s.jenkins@medcenter.org'),
        department: const Value('Cardiology')));
    await into(employees).insert(EmployeesCompanion.insert(
        id: emp2,
        employeeCode: 'EMP-002',
        name: 'Marcus Vance',
        email: const Value('m.vance@medcenter.org'),
        department: const Value('BioMed Engineering')));
    await into(employees).insert(EmployeesCompanion.insert(
        id: emp3,
        employeeCode: 'EMP-003',
        name: 'Elena Rostova',
        email: const Value('e.rostova@medcenter.org'),
        department: const Value('Clinical Operations')));
    await into(employees).insert(EmployeesCompanion.insert(
        id: emp4,
        employeeCode: 'EMP-004',
        name: 'David Chen',
        email: const Value('d.chen@medcenter.org'),
        department: const Value('Surgical Suite Ops')));

    // 5. Seed Medical Device Catalog Items
    final itemsData = [
      {
        'id': 'item_1',
        'name': 'Digital Precision Pipette Station',
        'sku': 'SKU-MED-PIP-01',
        'barcode': '8901234567890',
        'cat': labId,
        'cost': 1450.0,
        'sale': 1950.0,
        'qty': 8,
        'img': 'assets/images/pipette.png',
      },
      {
        'id': 'item_2',
        'name': 'Multi-Parameter Vital Signs Monitor',
        'sku': 'SKU-MED-MON-02',
        'barcode': '8901234567891',
        'cat': monId,
        'cost': 3200.0,
        'sale': 4500.0,
        'qty': 14,
        'img': 'assets/images/monitor.png',
      },
      {
        'id': 'item_3',
        'name': 'Diagnostic Stereo Microscope',
        'sku': 'SKU-MED-MIC-03',
        'barcode': '8901234567892',
        'cat': diagId,
        'cost': 2800.0,
        'sale': 3800.0,
        'qty': 5,
        'img': 'assets/images/microscope.png',
      },
      {
        'id': 'item_4',
        'name': 'Medical Grade Input Console',
        'sku': 'SKU-MED-KBD-04',
        'barcode': '8901234567893',
        'cat': surgId,
        'cost': 220.0,
        'sale': 350.0,
        'qty': 30,
        'img': 'assets/images/keyboard.png',
      },
      {
        'id': 'item_5',
        'name': 'Sanitizable Optical Sensor Controller',
        'sku': 'SKU-MED-MSE-05',
        'barcode': '8901234567894',
        'cat': surgId,
        'cost': 85.0,
        'sale': 140.0,
        'qty': 45,
        'img': 'assets/images/mouse.png',
      },
      {
        'id': 'item_6',
        'name': 'Surgical Suite Cubicle Modular Kit',
        'sku': 'SKU-MED-KIT-06',
        'barcode': '8901234567895',
        'cat': surgId,
        'cost': 5500.0,
        'sale': 7200.0,
        'qty': 3,
        'img': 'assets/images/cubicle_kit.png',
      },
    ];

    for (final it in itemsData) {
      final itemId = it['id'] as String;
      final qty = it['qty'] as int;

      await into(items).insert(
        ItemsCompanion.insert(
          id: itemId,
          sku: it['sku'] as String,
          name: it['name'] as String,
          barcode: Value(it['barcode'] as String),
          categoryId: Value(it['cat'] as String),
          costPrice: Value(it['cost'] as double),
          salePrice: Value(it['sale'] as double),
          imageUrl: Value(it['img'] as String),
        ),
      );

      await into(stockLevels).insert(
        StockLevelsCompanion.insert(
          itemId: itemId,
          warehouseId: mainWarehouseId,
          quantity: Value(qty),
        ),
      );

      await into(stockMovements).insert(
        StockMovementsCompanion.insert(
          id: uuid.v4(),
          itemId: itemId,
          targetWarehouseId: const Value(mainWarehouseId),
          movementType: 'in',
          quantity: qty,
          notes: const Value('Initial medical device catalog seed'),
        ),
      );
    }

    // 6. Seed Asset Handovers & Equipment Assignments
    final handover1Id = uuid.v4();
    await into(handovers).insert(
      HandoversCompanion.insert(
        id: handover1Id,
        itemId: 'item_1',
        employeeId: emp1,
        assignmentType: 'permanent',
        projectName: const Value('Cardiovascular Diagnostic Unit'),
        status: const Value('active'),
        notes: const Value('Primary lab pipette assigned to Dr. Jenkins'),
      ),
    );

    final handover2Id = uuid.v4();
    await into(handovers).insert(
      HandoversCompanion.insert(
        id: handover2Id,
        itemId: 'item_2',
        employeeId: emp2,
        assignmentType: 'temporary',
        projectName: const Value('ICU Field Deployment Trial'),
        dueDate:
            Value(now.subtract(const Duration(days: 2))), // Overdue return test
        status: const Value('overdue'),
        notes: const Value('Issued for 14-day clinical monitoring trial'),
      ),
    );
  }
}
