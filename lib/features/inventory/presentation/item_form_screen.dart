import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import 'providers/inventory_provider.dart';

class ItemFormScreen extends ConsumerStatefulWidget {
  final String? itemId;

  const ItemFormScreen({
    super.key,
    this.itemId,
  });

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _costController = TextEditingController();
  final _saleController = TextEditingController();
  final _reorderController = TextEditingController(text: '5');
  final _uomController = TextEditingController(text: 'each');
  String? _selectedCategoryId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.itemId != null) {
      _loadExistingItem();
    }
  }

  Future<void> _loadExistingItem() async {
    final db = ref.read(databaseProvider);
    final item = await (db.select(db.items)..where((t) => t.id.equals(widget.itemId!))).getSingleOrNull();

    if (item != null && mounted) {
      setState(() {
        _nameController.text = item.name;
        _skuController.text = item.sku;
        _barcodeController.text = item.barcode ?? '';
        _costController.text = item.costPrice.toString();
        _saleController.text = item.salePrice.toString();
        _reorderController.text = item.reorderPoint.toString();
        _uomController.text = item.unitOfMeasure;
        _selectedCategoryId = item.categoryId;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _costController.dispose();
    _saleController.dispose();
    _reorderController.dispose();
    _uomController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final db = ref.read(databaseProvider);
    final id = widget.itemId ?? 'item_${DateTime.now().millisecondsSinceEpoch}';
    final isEditing = widget.itemId != null;

    final cost = double.tryParse(_costController.text) ?? 0.0;
    final sale = double.tryParse(_saleController.text) ?? 0.0;
    final reorder = int.tryParse(_reorderController.text) ?? 5;

    final companion = ItemsCompanion.insert(
      id: id,
      name: _nameController.text.trim(),
      sku: _skuController.text.trim(),
      barcode: drift.Value(_barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim()),
      categoryId: drift.Value(_selectedCategoryId),
      costPrice: drift.Value(cost),
      salePrice: drift.Value(sale),
      reorderPoint: drift.Value(reorder),
      unitOfMeasure: drift.Value(_uomController.text.trim()),
    );

    if (isEditing) {
      await (db.update(db.items)..where((t) => t.id.equals(id))).write(companion);
    } else {
      await db.into(db.items).insert(companion);

      // Create initial stock level in main warehouse
      final mainWh = (await db.select(db.warehouses).get()).firstOrNull;
      if (mainWh != null) {
        await db.into(db.stockLevels).insert(
              StockLevelsCompanion.insert(
                itemId: id,
                warehouseId: mainWh.id,
                quantity: const drift.Value(10),
              ),
            );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditing ? 'Item updated' : 'Item created successfully')),
      );
      context.go('/inventory');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final isEditing = widget.itemId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Item' : 'New Item'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left),
          onPressed: () => context.go('/inventory'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('General Information', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Item Name *', prefixIcon: Icon(LucideIcons.box, size: 18)),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _skuController,
                            decoration: const InputDecoration(labelText: 'SKU Code *', prefixIcon: Icon(LucideIcons.barcode, size: 18)),
                            validator: (val) => val == null || val.trim().isEmpty ? 'SKU is required' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _barcodeController,
                            decoration: const InputDecoration(labelText: 'Barcode / EAN', prefixIcon: Icon(LucideIcons.qr_code, size: 18)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    categoriesAsync.when(
                      data: (cats) {
                        return DropdownButtonFormField<String>(
                          initialValue: _selectedCategoryId ?? cats.firstOrNull?.id,
                          decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(LucideIcons.folder, size: 18)),
                          items: cats.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                          onChanged: (val) => setState(() => _selectedCategoryId = val),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pricing & Inventory Thresholds', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _costController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Cost Price (\$)', prefixIcon: Icon(LucideIcons.dollar_sign, size: 18)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _saleController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Selling Price (\$)', prefixIcon: Icon(LucideIcons.tag, size: 18)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _reorderController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Reorder Threshold', prefixIcon: Icon(LucideIcons.triangle_alert, size: 18)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _uomController,
                            decoration: const InputDecoration(labelText: 'Unit of Measure', prefixIcon: Icon(LucideIcons.ruler, size: 18)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveForm,
                icon: const Icon(LucideIcons.check),
                label: Text(isEditing ? 'Update Item' : 'Save & Register Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
