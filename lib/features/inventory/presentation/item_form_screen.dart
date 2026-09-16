import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/widgets/app_page_header.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../core/widgets/app_surface.dart';
import '../../../core/widgets/app_buttons.dart';
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
    final item = await (db.select(db.items)
          ..where((t) => t.id.equals(widget.itemId!)))
        .getSingleOrNull();

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
      barcode: drift.Value(_barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim()),
      categoryId: drift.Value(_selectedCategoryId),
      costPrice: drift.Value(cost),
      salePrice: drift.Value(sale),
      reorderPoint: drift.Value(reorder),
      unitOfMeasure: drift.Value(_uomController.text.trim()),
    );

    if (isEditing) {
      await (db.update(db.items)..where((t) => t.id.equals(id)))
          .write(companion);
    } else {
      await db.into(db.items).insert(companion);

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
        SnackBar(
            content: Text(isEditing
                ? 'Medical device specification updated'
                : 'Medical device registered successfully')),
      );
      context.go('/inventory');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final isEditing = widget.itemId != null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppPageHeader(
                  title: isEditing
                      ? 'Edit Device Specification'
                      : 'Register Medical Device',
                  subtitle:
                      'Configure device catalog parameters, serial tags, and stock thresholds',
                  secondaryAction: AppSecondaryButton(
                    label: 'Cancel',
                    icon: AppIcons.back,
                    onPressed: () => context.go('/inventory'),
                  ),
                ),
                const SizedBox(height: 20),
                const AppSectionHeader(title: 'Device Identification'),
                AppSurface(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                            labelText: 'Medical Device Name *',
                            prefixIcon: Icon(AppIcons.asset, size: 18)),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Device name is required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _skuController,
                              decoration: const InputDecoration(
                                  labelText: 'SKU / Model Code *',
                                  prefixIcon:
                                      Icon(AppIcons.serialNumber, size: 18)),
                              validator: (val) =>
                                  val == null || val.trim().isEmpty
                                      ? 'SKU is required'
                                      : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _barcodeController,
                              decoration: const InputDecoration(
                                  labelText: 'Asset Tag / Serial Barcode',
                                  prefixIcon:
                                      Icon(AppIcons.scanActive, size: 18)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      categoriesAsync.when(
                        data: (cats) {
                          return DropdownButtonFormField<String>(
                            initialValue:
                                _selectedCategoryId ?? cats.firstOrNull?.id,
                            decoration: const InputDecoration(
                                labelText: 'Device Category',
                                prefixIcon: Icon(AppIcons.category, size: 18)),
                            items: cats
                                .map((c) => DropdownMenuItem(
                                    value: c.id, child: Text(c.name)))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedCategoryId = val),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const AppSectionHeader(
                    title: 'Valuation & Inventory Thresholds'),
                AppSurface(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _costController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Acquisition Cost (\$)',
                                  prefixIcon:
                                      Icon(AppIcons.available, size: 18)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _saleController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Catalog Value (\$)',
                                  prefixIcon:
                                      Icon(AppIcons.batchNumber, size: 18)),
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
                              decoration: const InputDecoration(
                                  labelText: 'Reorder Alert Threshold',
                                  prefixIcon: Icon(AppIcons.warning, size: 18)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _uomController,
                              decoration: const InputDecoration(
                                  labelText: 'Unit of Measure',
                                  prefixIcon:
                                      Icon(AppIcons.category, size: 18)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: AppPrimaryButton(
                    label: _isLoading
                        ? 'Saving Device...'
                        : (isEditing
                            ? 'Update Specification'
                            : 'Save & Register Device'),
                    icon: AppIcons.success,
                    onPressed: _isLoading ? () {} : _saveForm,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
