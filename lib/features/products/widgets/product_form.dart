
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductForm extends StatefulWidget {
  final String? productId;

  const ProductForm({super.key, this.productId});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.productId != null) {
        _editedProduct = Provider.of<ProductProvider>(context, listen: false)
            .findById(widget.productId!);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl ?? '';
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_editedProduct.id.isNotEmpty) {
        await Provider.of<ProductProvider>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } else {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProduct(_editedProduct);
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('Something went wrong.'),
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
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              initialValue: _initValues['title'],
              decoration: const InputDecoration(
                labelText: 'Product Name',
                hintText: 'e.g., Industrial Grade Screwdriver',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a product name.';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = _editedProduct.copyWith(title: value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _initValues['price'],
              decoration: const InputDecoration(
                labelText: 'Price',
                hintText: 'e.g., 29.99',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              textInputAction: TextInputAction.next,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
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
                _editedProduct =
                    _editedProduct.copyWith(price: double.parse(value!));
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _initValues['description'],
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Detailed description of the product...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              focusNode: _descriptionFocusNode,
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
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: _imageUrlController.text.isEmpty
                      ? Center(
                          child: Text(
                          'No Image',
                          style: TextStyle(color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                            loadingBuilder: (ctx, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (ctx, error, stackTrace) {
                              return Center(
                                  child: Icon(
                                Icons.error_outline,
                                color: Colors.red.shade400,
                              ));
                            },
                          ),
                        ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      hintText: 'https://example.com/image.png',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                    focusNode: _imageUrlFocusNode,
                    onFieldSubmitted: (_) => _saveForm(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an image URL.';
                      }
                      bool isValidUrl = Uri.tryParse(value)?.hasAbsolutePath ?? false;
                      if (!isValidUrl) {
                        return 'Please enter a valid URL.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = _editedProduct.copyWith(imageUrl: value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: _isLoading
                    ? const SizedBox.shrink()
                    : const Icon(Icons.save),
                label: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Save Product'),
                onPressed: _isLoading ? null : _saveForm,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
