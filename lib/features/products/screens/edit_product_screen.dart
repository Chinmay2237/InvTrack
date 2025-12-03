import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:myapp/features/products/models/product.dart';
import 'package:myapp/features/products/providers/product_provider.dart';
import 'package:myapp/features/products/widgets/image_picker_widget.dart';
import 'package:myapp/core/widgets/ui_helper.dart';

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
        await Provider.of<ProductProvider>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
      } else {
        await Provider.of<ProductProvider>(context, listen: false).addProduct(_editedProduct, _pickedImage);
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
    final theme = Theme.of(context);

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
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ImagePickerWidget(
                        initialImageUrl: _editedProduct.imageUrl,
                        onImagePicked: (image) {
                          _pickedImage = image;
                        },
                      ),
                      UIHelper.verticalSpaceMedium,
                      TextFormField(
                        initialValue: _editedProduct.name,
                        decoration: const InputDecoration(labelText: 'Name'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = _editedProduct.copyWith(name: value);
                        },
                      ),
                      UIHelper.verticalSpaceMedium,
                      TextFormField(
                        initialValue: _editedProduct.category,
                        decoration: const InputDecoration(labelText: 'Category'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a category.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = _editedProduct.copyWith(category: value);
                        },
                      ),
                      UIHelper.verticalSpaceMedium,
                      TextFormField(
                        initialValue: _editedProduct.price.toString(),
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = _editedProduct.copyWith(price: double.parse(value!));
                        },
                      ),
                      UIHelper.verticalSpaceMedium,
                      TextFormField(
                        initialValue: _editedProduct.quantity.toString(),
                        decoration: const InputDecoration(labelText: 'Quantity'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a quantity.';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid integer.';
                          }
                          if (int.parse(value) < 0) {
                            return 'Please enter a non-negative number.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = _editedProduct.copyWith(quantity: int.parse(value!));
                        },
                      ),
                      UIHelper.verticalSpaceMedium,
                      TextFormField(
                        initialValue: _editedProduct.description,
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description.';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = _editedProduct.copyWith(description: value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
