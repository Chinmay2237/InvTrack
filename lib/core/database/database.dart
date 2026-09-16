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
  TextColumn get movementType => text()(); // 'in', 'out', 'transfer', 'adjustment'
  IntColumn get quantity => integer()();
  TextColumn get referenceType => text().nullable()(); // 'po', 'so', 'handover', 'manual'
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
  DateTimeColumn get assignedDate => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get returnDate => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))(); // 'active', 'returned', 'overdue'
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
  TextColumn get status => text().withDefault(const Constant('draft'))(); // 'draft', 'submitted', 'received'
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

    // 3. Seed Categories
    const electronicsId = 'cat_elec';
    const footwearId = 'cat_footwear';
    const homeId = 'cat_home';
    const accId = 'cat_acc';

    await into(categories).insert(
      CategoriesCompanion.insert(
        id: electronicsId,
        name: 'Electronics',
        description: const Value('Computers, mobile devices & hardware'),
      ),
    );
    await into(categories).insert(
      CategoriesCompanion.insert(
        id: footwearId,
        name: 'Footwear',
        description: const Value('Safety shoes & workwear'),
      ),
    );
    await into(categories).insert(
      CategoriesCompanion.insert(
        id: homeId,
        name: 'Home & Office',
        description: const Value('Appliances & facility gear'),
      ),
    );
    await into(categories).insert(
      CategoriesCompanion.insert(
        id: accId,
        name: 'Accessories',
        description: const Value('Carrying cases & peripherals'),
      ),
    );

    // 4. Seed Employees
    const emp1 = 'E1';
    const emp2 = 'E2';
    const emp3 = 'E3';
    const emp4 = 'E4';

    await into(employees).insert(EmployeesCompanion.insert(id: emp1, employeeCode: 'EMP-001', name: 'Alice Smith', email: const Value('alice@company.com'), department: const Value('Engineering')));
    await into(employees).insert(EmployeesCompanion.insert(id: emp2, employeeCode: 'EMP-002', name: 'Bob Jones', email: const Value('bob@company.com'), department: const Value('Operations')));
    await into(employees).insert(EmployeesCompanion.insert(id: emp3, employeeCode: 'EMP-003', name: 'Charlie Brown', email: const Value('charlie@company.com'), department: const Value('Design')));
    await into(employees).insert(EmployeesCompanion.insert(id: emp4, employeeCode: 'EMP-004', name: 'Diana Prince', email: const Value('diana@company.com'), department: const Value('Management')));

    // 5. Seed Items (from InvTrack initial catalog)
    final itemsData = [
      {
        'id': 'item_1',
        'name': 'Laptop Pro 15',
        'sku': 'SKU-LAP-001',
        'barcode': '8901234567890',
        'cat': electronicsId,
        'cost': 950.0,
        'sale': 1200.0,
        'qty': 10,
        'img': 'assets/images/laptop.png',
      },
      {
        'id': 'item_2',
        'name': 'Smartphone Ultra',
        'sku': 'SKU-PHN-002',
        'barcode': '8901234567891',
        'cat': electronicsId,
        'cost': 600.0,
        'sale': 800.0,
        'qty': 25,
        'img': 'assets/images/smartphone.png',
      },
      {
        'id': 'item_3',
        'name': 'Office Coffee Maker',
        'sku': 'SKU-APL-003',
        'barcode': '8901234567892',
        'cat': homeId,
        'cost': 35.0,
        'sale': 50.0,
        'qty': 50,
        'img': 'assets/images/coffee_maker.png',
      },
      {
        'id': 'item_4',
        'name': 'Safety Running Shoes',
        'sku': 'SKU-SHS-004',
        'barcode': '8901234567893',
        'cat': footwearId,
        'cost': 80.0,
        'sale': 120.0,
        'qty': 100,
        'img': 'assets/images/running_shoes.png',
      },
      {
        'id': 'item_5',
        'name': 'Rugged Backpack',
        'sku': 'SKU-BAG-005',
        'barcode': '8901234567894',
        'cat': accId,
        'cost': 45.0,
        'sale': 75.0,
        'qty': 75,
        'img': 'assets/images/backpack.png',
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
          notes: const Value('Initial stock seed'),
        ),
      );
    }

    // 6. Seed Handovers (Permanent & Temporary)
    final handover1Id = uuid.v4();
    await into(handovers).insert(
      HandoversCompanion.insert(
        id: handover1Id,
        itemId: 'item_1',
        employeeId: emp1,
        assignmentType: 'permanent',
        projectName: const Value('Core Platform R&D'),
        status: const Value('active'),
        notes: const Value('Primary dev machine issued to Alice'),
      ),
    );

    final handover2Id = uuid.v4();
    await into(handovers).insert(
      HandoversCompanion.insert(
        id: handover2Id,
        itemId: 'item_2',
        employeeId: emp2,
        assignmentType: 'temporary',
        projectName: const Value('Field Testing Campaign'),
        dueDate: Value(now.subtract(const Duration(days: 2))), // Overdue return test
        status: const Value('overdue'),
        notes: const Value('Issued for 2-week testing field trial'),
      ),
    );
  }
}
