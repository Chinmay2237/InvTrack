import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:myapp/features/products/models/product.dart';
import 'package:myapp/features/products/providers/product_provider.dart';
import 'package:myapp/features/products/widgets/image_picker_widget.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  var _newProduct = Product(
    id: '',
    name: '',
    category: '',
    price: 0,
    description: '',
    imageUrl: '',
    quantity: 0,
  );
  var _isLoading = false;
  File? _pickedImage;

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    try {
      Provider.of<ProductProvider>(context, listen: false).addProduct(_newProduct, _pickedImage);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt_rounded),
            onPressed: _saveForm,
            tooltip: 'Save Product',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: ImagePickerWidget(
                          onImagePicked: (image) {
                            _pickedImage = image;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Product Details', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        labelText: 'Product Name',
                        icon: Icons.label_outline_rounded,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please provide a name.' : null,
                        onSaved: (value) => _newProduct = _newProduct.copyWith(name: value),
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        labelText: 'Category',
                        icon: Icons.category_outlined,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please provide a category.' : null,
                        onSaved: (value) => _newProduct = _newProduct.copyWith(category: value),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                              labelText: 'Price',
                              icon: Icons.attach_money_rounded,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Enter a price.';
                                if (double.tryParse(value) == null) return 'Enter a valid number.';
                                if (double.parse(value) <= 0) return 'Must be > 0.';
                                return null;
                              },
                              onSaved: (value) => _newProduct = _newProduct.copyWith(price: double.parse(value!)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextFormField(
                              labelText: 'Quantity',
                              icon: Icons.production_quantity_limits_rounded,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Enter a quantity.';
                                if (int.tryParse(value) == null) return 'Enter a valid number.';
                                if (int.parse(value) < 0) return 'Must be >= 0.';
                                return null;
                              },
                              onSaved: (value) => _newProduct = _newProduct.copyWith(quantity: int.parse(value!)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        labelText: 'Description',
                        icon: Icons.description_outlined,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter a description.';
                          if (value.length < 10) return 'Should be at least 10 characters long.';
                          return null;
                        },
                        onSaved: (value) => _newProduct = _newProduct.copyWith(description: value),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add_shopping_cart_rounded),
                          label: const Text('Add Product'),
                          onPressed: _saveForm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextFormField({
    required String labelText,
    required IconData icon,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    TextInputType? keyboardType,
    int? maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
      textInputAction: maxLines == 1 ? TextInputAction.next : TextInputAction.done,
    );
  }
}
