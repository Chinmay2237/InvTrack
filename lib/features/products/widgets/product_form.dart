import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invtrack/core/constants/app_constants.dart';
import 'package:invtrack/features/products/models/product.dart';

class ProductForm extends StatefulWidget {
  final Product? initialProduct;
  final Function(Product, File?) onSave;

  const ProductForm({super.key, this.initialProduct, required this.onSave});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _serialNumberController;
  late TextEditingController _costController;
  late TextEditingController _priceController;
  late TextEditingController _assignedToController;
  late TextEditingController _notesController;
  late String _selectedCategory;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProduct?.name);
    _serialNumberController =
        TextEditingController(text: widget.initialProduct?.serialNumber);
    _costController = TextEditingController(
        text: widget.initialProduct?.cost.toStringAsFixed(2));
    _priceController = TextEditingController(
        text: widget.initialProduct?.price.toStringAsFixed(2));
    _assignedToController =
        TextEditingController(text: widget.initialProduct?.assignedTo);
    _notesController = TextEditingController(text: widget.initialProduct?.notes);
    _selectedCategory =
        widget.initialProduct?.category ?? AppConstants.categories.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serialNumberController.dispose();
    _costController.dispose();
    _priceController.dispose();
    _assignedToController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.initialProduct?.id ?? '',
        name: _nameController.text,
        category: _selectedCategory,
        serialNumber: _serialNumberController.text,
        cost: double.tryParse(_costController.text) ?? 0.0,
        price: double.tryParse(_priceController.text) ?? 0.0,
        assignedTo: _assignedToController.text,
        notes: _notesController.text,
        imageUrl: widget.initialProduct?.imageUrl ?? '',
        createdAt: widget.initialProduct?.createdAt,
      );
      widget.onSave(product, _imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImagePicker(),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon: Icon(Icons.shopping_bag_outlined)),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: AppConstants.categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
              decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _serialNumberController,
              decoration: const InputDecoration(
                  labelText: 'Serial Number',
                  prefixIcon: Icon(Icons.qr_code_scanner_outlined)),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a serial number' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _costController,
              decoration: const InputDecoration(
                  labelText: 'Cost',
                  prefixIcon: Icon(Icons.attach_money_outlined)),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a cost' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.attach_money_outlined)),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a price' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _assignedToController,
              decoration: const InputDecoration(
                  labelText: 'Assigned To',
                  prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                  labelText: 'Notes', prefixIcon: Icon(Icons.note_outlined)),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _onSave,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(widget.initialProduct == null
                  ? 'Add Product'
                  : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: DottedBorder(
          // strokeWidth: 2,
          child: InkWell(
            onTap: _pickImage,
            child: Container(
              alignment: Alignment.center,
              child: _imageFile != null
                  ? Image.file(_imageFile!, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                  : (widget.initialProduct?.imageUrl.isNotEmpty ?? false)
                      ? Image.network(widget.initialProduct!.imageUrl,
                          fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined,
                                size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Upload Image',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
