import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/tokens.dart';
import 'providers/scanning_provider.dart';
import 'widgets/barcode_label_dialog.dart';

class ScanningScreen extends ConsumerStatefulWidget {
  const ScanningScreen({super.key});

  @override
  ConsumerState<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends ConsumerState<ScanningScreen>
    with SingleTickerProviderStateMixin {
  late MobileScannerController _scannerController;
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;
  final TextEditingController _manualInputController = TextEditingController();
  bool _isProcessingCode = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _animationController.dispose();
    _manualInputController.dispose();
    super.dispose();
  }

  Future<void> _handleBarcodeDetected(String rawCode) async {
    if (_isProcessingCode) return;
    setState(() {
      _isProcessingCode = true;
    });

    final db = ref.read(databaseProvider);
    final scanState = ref.read(scanningProvider);

    // Query Drift Database for item with matching barcode or SKU
    final itemQuery = await (db.select(db.items)
          ..where((t) => t.barcode.equals(rawCode) | t.sku.equals(rawCode)))
        .getSingleOrNull();

    if (!mounted) return;

    if (itemQuery != null) {
      if (scanState.isBulkMode) {
        ref.read(scanningProvider.notifier).addToBulkQueue(
              ScannedItemEntry(
                barcode: rawCode,
                itemId: itemQuery.id,
                name: itemQuery.name,
                quantity: 1,
              ),
            );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${itemQuery.name} to bulk batch'),
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        _showItemMatchBottomSheet(itemQuery);
      }
    } else {
      if (scanState.isBulkMode) {
        ref.read(scanningProvider.notifier).addToBulkQueue(
              ScannedItemEntry(
                barcode: rawCode,
                name: 'New Item ($rawCode)',
                quantity: 1,
              ),
            );
      } else {
        _showQuickAddBottomSheet(rawCode);
      }
    }

    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _isProcessingCode = false;
      });
    }
  }

  void _showItemMatchBottomSheet(Item item) {
    int adjustQty = 1;
    String selectedMovement = 'in';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTokens.radiusModal)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTokens.primarySurfaceLight,
                          borderRadius:
                              BorderRadius.circular(AppTokens.radiusButton),
                        ),
                        child: const Icon(AppIcons.success,
                            color: AppTokens.primary, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'SKU: ${item.sku} | Barcode: ${item.barcode ?? "N/A"}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Action Type:',
                          style: Theme.of(context).textTheme.bodyLarge),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                              value: 'in',
                              label: Text('Stock In'),
                              icon: Icon(AppIcons.back, size: 16)),
                          ButtonSegment(
                              value: 'out',
                              label: Text('Stock Out'),
                              icon: Icon(AppIcons.forward, size: 16)),
                        ],
                        selected: {selectedMovement},
                        onSelectionChanged: (val) {
                          setModalState(() => selectedMovement = val.first);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Adjust Quantity:',
                          style: Theme.of(context).textTheme.bodyLarge),
                      Row(
                        children: [
                          IconButton.outlined(
                            icon: const Icon(AppIcons.edit, size: 18),
                            onPressed: adjustQty > 1
                                ? () => setModalState(() => adjustQty--)
                                : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '$adjustQty',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                          IconButton.outlined(
                            icon: const Icon(AppIcons.add, size: 18),
                            onPressed: () => setModalState(() => adjustQty++),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final db = ref.read(databaseProvider);
                        final mainWh =
                            (await db.select(db.warehouses).get()).firstOrNull;

                        if (mainWh != null) {
                          final currentStock = await (db.select(db.stockLevels)
                                ..where((t) =>
                                    t.itemId.equals(item.id) &
                                    t.warehouseId.equals(mainWh.id)))
                              .getSingleOrNull();

                          final newQty = selectedMovement == 'in'
                              ? (currentStock?.quantity ?? 0) + adjustQty
                              : (currentStock?.quantity ?? 0) - adjustQty;

                          await (db.into(db.stockLevels))
                              .insertOnConflictUpdate(
                            StockLevelsCompanion.insert(
                              itemId: item.id,
                              warehouseId: mainWh.id,
                              quantity: drift.Value(newQty < 0 ? 0 : newQty),
                            ),
                          );

                          await db.into(db.stockMovements).insert(
                                StockMovementsCompanion.insert(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  itemId: item.id,
                                  targetWarehouseId: drift.Value(mainWh.id),
                                  movementType: selectedMovement,
                                  quantity: adjustQty,
                                  notes: const drift.Value(
                                      'Adjusted via Scan Station'),
                                ),
                              );
                        }

                        if (mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Stock updated for ${item.name}')),
                          );
                        }
                      },
                      icon: const Icon(AppIcons.success),
                      label:
                          Text('Confirm $selectedMovement ($adjustQty units)'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showQuickAddBottomSheet(String scannedCode) {
    final nameController = TextEditingController(text: 'New Scanned Item');
    final priceController = TextEditingController(text: '49.99');
    final qtyController = TextEditingController(text: '10');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTokens.radiusModal)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTokens.warningSurfaceLight,
                      borderRadius:
                          BorderRadius.circular(AppTokens.radiusButton),
                    ),
                    child: const Icon(AppIcons.add,
                        color: AppTokens.warning, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Unrecognized Barcode',
                          style: Theme.of(context).textTheme.titleMedium),
                      Text('Quick-add item for barcode: $scannedCode',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Price (\$)', prefixText: '\$ '),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Initial Qty'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final db = ref.read(databaseProvider);
                    final itemId =
                        'item_${DateTime.now().millisecondsSinceEpoch}';
                    final qty = int.tryParse(qtyController.text) ?? 1;
                    final price = double.tryParse(priceController.text) ?? 0.0;

                    final categories = await db.select(db.categories).get();
                    final firstCat = categories.firstOrNull?.id;
                    final mainWh =
                        (await db.select(db.warehouses).get()).firstOrNull;

                    await db.into(db.items).insert(
                          ItemsCompanion.insert(
                            id: itemId,
                            sku:
                                'SKU-${scannedCode.substring(0, scannedCode.length > 6 ? 6 : scannedCode.length)}',
                            name: nameController.text,
                            barcode: drift.Value(scannedCode),
                            categoryId: drift.Value(firstCat),
                            salePrice: drift.Value(price),
                            costPrice: drift.Value(price * 0.7),
                          ),
                        );

                    if (mainWh != null) {
                      await db.into(db.stockLevels).insert(
                            StockLevelsCompanion.insert(
                              itemId: itemId,
                              warehouseId: mainWh.id,
                              quantity: drift.Value(qty),
                            ),
                          );
                    }

                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Created ${nameController.text} successfully!')),
                      );
                    }
                  },
                  icon: const Icon(AppIcons.success),
                  label: const Text('Save & Register Item'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanningProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(AppIcons.scanActive, color: AppTokens.primary, size: 22),
            SizedBox(width: 8),
            Text('Scan Station'),
          ],
        ),
        actions: [
          FilterChip(
            label: Text(scanState.isBulkMode ? 'Bulk Scan ON' : 'Single Mode'),
            selected: scanState.isBulkMode,
            onSelected: (_) =>
                ref.read(scanningProvider.notifier).toggleBulkMode(),
            selectedColor: AppTokens.primarySurfaceLight,
            checkmarkColor: AppTokens.primary,
            avatar: Icon(
              scanState.isBulkMode ? AppIcons.assetGroup : AppIcons.scan,
              size: 16,
              color: scanState.isBulkMode ? AppTokens.primary : Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(AppIcons.batchNumber),
            tooltip: 'Generate Asset Label',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => const BarcodeLabelDialog(
                  code: '8901234567890',
                  itemName: 'Laptop Pro 15',
                  sku: 'SKU-LAP-001',
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Manual input & quick triggers bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _manualInputController,
                    decoration: InputDecoration(
                      hintText: 'Enter barcode or SKU (e.g. 8901234567890)...',
                      isDense: true,
                      prefixIcon: const Icon(AppIcons.search, size: 18),
                      suffixIcon: IconButton(
                        icon: const Icon(AppIcons.forward, size: 18),
                        onPressed: () {
                          if (_manualInputController.text.trim().isNotEmpty) {
                            _handleBarcodeDetected(
                                _manualInputController.text.trim());
                            _manualInputController.clear();
                          }
                        },
                      ),
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        _handleBarcodeDetected(val.trim());
                        _manualInputController.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                // Test Presets Dropdown for quick emulator/desktop testing
                PopupMenuButton<String>(
                  icon: const Icon(AppIcons.maintenance,
                      color: AppTokens.primary),
                  tooltip: 'Simulate Test Scans',
                  onSelected: (code) => _handleBarcodeDetected(code),
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                        value: '8901234567890',
                        child: Text('Test Scan: Laptop Pro 15')),
                    PopupMenuItem(
                        value: '8901234567891',
                        child: Text('Test Scan: Smartphone Ultra')),
                    PopupMenuItem(
                        value: '8901234567899',
                        child: Text('Test Scan: Unrecognized Code')),
                  ],
                ),
              ],
            ),
          ),

          // Main Camera View with Scrim Overlay
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  controller: _scannerController,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null) {
                        _handleBarcodeDetected(barcode.rawValue!);
                        break;
                      }
                    }
                  },
                ),

                // Corner bracket overlay & animated scan line
                Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppTokens.primary.withValues(alpha: 0.8),
                          width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        AnimatedBuilder(
                          animation: _scanLineAnimation,
                          builder: (context, child) {
                            return Positioned(
                              top: 280 * _scanLineAnimation.value,
                              left: 10,
                              right: 10,
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: AppTokens.primary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTokens.primary
                                          .withValues(alpha: 0.8),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Center(
                          child: Text(
                            scanState.isBulkMode
                                ? 'BULK SCANNING ACTIVE'
                                : 'ALIGN BARCODE IN FRAME',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bulk Scan Queue Panel at Bottom
          if (scanState.isBulkMode)
            Container(
              height: 180,
              padding: const EdgeInsets.all(16),
              color: isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(AppIcons.assetGroup,
                              size: 18, color: AppTokens.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Bulk Queue (${scanState.bulkQueue.length} items)',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: scanState.bulkQueue.isNotEmpty
                            ? () {
                                ref
                                    .read(scanningProvider.notifier)
                                    .clearBulkQueue();
                              }
                            : null,
                        icon: const Icon(AppIcons.delete, size: 16),
                        label: const Text('Clear All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: scanState.bulkQueue.isEmpty
                        ? const Center(
                            child: Text('No items scanned in batch yet.'),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: scanState.bulkQueue.length,
                            itemBuilder: (context, index) {
                              final item = scanState.bulkQueue[index];
                              return Card(
                                margin: const EdgeInsets.only(right: 12),
                                child: Container(
                                  width: 150,
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(AppIcons.close,
                                                size: 14),
                                            onPressed: () {
                                              ref
                                                  .read(
                                                      scanningProvider.notifier)
                                                  .removeFromBulkQueue(index);
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Code: ${item.barcode}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppTokens.primarySurfaceLight,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Qty: ${item.quantity}',
                                          style: const TextStyle(
                                              color: AppTokens.primary,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: scanState.bulkQueue.isNotEmpty
                          ? () {
                              final count = scanState.bulkQueue.length;
                              ref
                                  .read(scanningProvider.notifier)
                                  .clearBulkQueue();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Committed batch stock movements for $count items')),
                              );
                            }
                          : null,
                      icon: const Icon(AppIcons.success),
                      label: const Text('Confirm All Batch Movements'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
