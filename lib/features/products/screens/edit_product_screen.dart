import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:myapp/features/products/models/product.dart';
import 'package:myapp/features/products/providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final String? productId;

  const EditProductScreen({super.key, this.productId});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    name: '',
    category: '',
    price: 0,
    description: '',
    imageUrl: '',
    quantity: 0,
  );
  var _isInit = true;
  var _isLoading = false;
  File? _pickedImage;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.productId != null) {
        _editedProduct = Provider.of<ProductProvider>(context, listen: false).findById(widget.productId!);
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

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
      if (_editedProduct.id.isNotEmpty) {
        Provider.of<ProductProvider>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
      } else {
        Provider.of<ProductProvider>(context, listen: false).addProduct(_editedProduct, _pickedImage);
      }
      Navigator.of(context).pop();
    } catch (error) {
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productId == null ? 'Add Product' : 'Edit Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 24),
                      _buildTextFormField(
                        initialValue: _editedProduct.name,
                        labelText: 'Name',
                        validator: (value) => (value == null || value.isEmpty) ? 'Please provide a name.' : null,
                        onSaved: (value) => _editedProduct = _editedProduct.copyWith(name: value),
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        initialValue: _editedProduct.category,
                        labelText: 'Category',
                        validator: (value) => (value == null || value.isEmpty) ? 'Please provide a category.' : null,
                        onSaved: (value) => _editedProduct = _editedProduct.copyWith(category: value),
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        initialValue: _editedProduct.price.toString(),
                        labelText: 'Price',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter a price.';
                          if (double.tryParse(value) == null) return 'Please enter a valid number.';
                          if (double.parse(value) <= 0) return 'Please enter a number greater than zero.';
                          return null;
                        },
                        onSaved: (value) => _editedProduct = _editedProduct.copyWith(price: double.parse(value!)),
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        initialValue: _editedProduct.quantity.toString(),
                        labelText: 'Quantity',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter a quantity.';
                          if (int.tryParse(value) == null) return 'Please enter a valid integer.';
                          if (int.parse(value) < 0) return 'Please enter a non-negative number.';
                          return null;
                        },
                        onSaved: (value) => _editedProduct = _editedProduct.copyWith(quantity: int.parse(value!)),
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        initialValue: _editedProduct.description,
                        labelText: 'Description',
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter a description.';
                          if (value.length < 10) return 'Should be at least 10 characters long.';
                          return null;
                        },
                        onSaved: (value) => _editedProduct = _editedProduct.copyWith(description: value),
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
    String? initialValue,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    TextInputType? keyboardType,
    int? maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
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
