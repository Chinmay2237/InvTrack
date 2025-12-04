import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

import '../providers/product_provider.dart';
import '../models/product.dart';

class ProductFormScreen extends StatefulWidget {
  final String? productId;

  const ProductFormScreen({super.key, this.productId});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late Product _product;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  bool get _isEditing => widget.productId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final existingProduct = Provider.of<ProductProvider>(context, listen: false).findById(widget.productId!);
      _product = existingProduct.copyWith();
    } else {
      _product = const Product(id: '', name: '', description: '', price: 0, category: '', quantity: 0, imageUrl: '');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _product = _product.copyWith(imageUrl: pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      if (_isEditing) {
        productProvider.updateProduct(_product.id, _product);
      } else {
        productProvider.addProduct(_product, _imageFile);
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(theme),
              const SizedBox(height: 32),
              _buildCard([
                _buildTextFormField(
                  initialValue: _product.name,
                  labelText: 'Product Name',
                  validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                  onSaved: (value) => _product = _product.copyWith(name: value),
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  initialValue: _product.description,
                  labelText: 'Description',
                  maxLines: 3,
                  onSaved: (value) => _product = _product.copyWith(description: value),
                ),
              ]),
              const SizedBox(height: 24),
              _buildCard([
                _buildTextFormField(
                  initialValue: _product.price.toStringAsFixed(2),
                  labelText: 'Price',
                  prefixText: '\$',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => double.tryParse(value!) == null ? 'Invalid price' : null,
                  onSaved: (value) => _product = _product.copyWith(price: double.parse(value!)),
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  initialValue: _product.category,
                  labelText: 'Category',
                  onSaved: (value) => _product = _product.copyWith(category: value),
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  initialValue: _product.quantity.toString(),
                  labelText: 'Quantity',
                  keyboardType: TextInputType.number,
                  validator: (value) => int.tryParse(value!) == null ? 'Invalid quantity' : null,
                  onSaved: (value) => _product = _product.copyWith(quantity: int.parse(value!)),
                ),
              ]),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: Text(_isEditing ? 'Update Product' : 'Create Product'),
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildImagePicker(ThemeData theme) {
    return GestureDetector(
      onTap: _pickImage,
      child: DottedBorder(
        color: theme.colorScheme.onSurface.withAlpha(102),
        strokeWidth: 2,
        dashPattern: const [8, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface.withAlpha(50),
          ),
          child: _imageFile != null || (_isEditing && _product.imageUrl.isNotEmpty)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _imageFile ?? File(_product.imageUrl),
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 50, color: theme.colorScheme.primary),
                    const SizedBox(height: 8),
                    Text('Upload Image', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                    Text('Tap to select from gallery', style: theme.textTheme.bodySmall),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    String? initialValue,
    required String labelText,
    String? prefixText,
    int? maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        prefixText: prefixText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
