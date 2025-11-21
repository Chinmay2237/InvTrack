import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/core/services/firestore_service.dart';
import 'package:invtrack/features/products/models/product.dart';
import 'package:provider/provider.dart';

class EditProductPage extends StatefulWidget {
  final String category;
  final String productId;
  const EditProductPage(
      {super.key, required this.category, required this.productId});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _serialNumberController;
  String? _selectedCategory;
  late TextEditingController _costController;
  late TextEditingController _assignedToController;
  late TextEditingController _notesController;
  String? _imageUrl; // Existing image URL from Firestore
  Uint8List? _selectedImageBytes; // New image selected by user
  String? _selectedImageFileName;

  Product? _currentProduct;
  bool _isLoadingProduct = true;
  bool _isSavingProduct = false;
  bool _isPickingImage = false;
  bool _isUploadingImage = false; // Added for image upload progress

  final List<String> _categories = [
    'Laptops',
    'Mobiles',
    'Accessories',
    'Furniture',
    'Others'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _serialNumberController = TextEditingController();
    _costController = TextEditingController();
    _assignedToController = TextEditingController();
    _notesController = TextEditingController();
    _loadProduct();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serialNumberController.dispose();
    _costController.dispose();
    _assignedToController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoadingProduct = true;
    });
    try {
      final firestoreService =
          Provider.of<FirestoreService>(context, listen: false);
      final product = await firestoreService.getProductById(widget.productId);
      if (mounted) {
        setState(() {
          _currentProduct = product;
          _nameController.text = product.name;
          _serialNumberController.text = product.serialNumber;
          _selectedCategory = product.category;
          _costController.text = product.cost.toString();
          _assignedToController.text = product.assignedTo;
          _notesController.text = product.notes;
          _imageUrl = product.imageUrl;
          _isLoadingProduct = false;
        });
      }
    } catch (e, s) {
      developer.log(
        '[InvTrack] Error loading product: $e',
        name: 'edit_product_page',
        error: e,
        stackTrace: s,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load product: $e'),
              backgroundColor: Colors.red),
        );
        setState(() {
          _isLoadingProduct = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    setState(() {
      _isPickingImage = true;
    });
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // This is crucial for web to get bytes
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _selectedImageBytes = result.files.single.bytes;
          _selectedImageFileName = result.files.single.name;
          _imageUrl = null; // Clear existing image URL if a new image is picked
        });
        developer.log(
            '[InvTrack] Image picked: ${_selectedImageFileName ?? 'unknown'}',
            name: 'edit_product_page');
      }
    } catch (e, s) {
      developer.log(
        '[InvTrack] Error picking image: $e',
        name: 'edit_product_page',
        error: e,
        stackTrace: s,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to pick image: $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  void _clearSelectedImage() {
    setState(() {
      _selectedImageBytes = null;
      _selectedImageFileName = null;
      _imageUrl = _currentProduct?.imageUrl; // Revert to original image if any
    });
    developer.log('[InvTrack] Selected image cleared', name: 'edit_product_page');
  }


  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate() && _currentProduct != null) {
      setState(() {
        _isSavingProduct = true;
      });
      final firestoreService =
          Provider.of<FirestoreService>(context, listen: false);
      try {
        String? newImageUrl = _imageUrl; // Start with the existing image URL

        // If a new image is selected, upload it
        if (_selectedImageBytes != null && _selectedImageFileName != null) {
          setState(() {
            _isUploadingImage = true;
          });
          newImageUrl = await firestoreService.uploadProductImage(
            widget.productId,
            _selectedImageBytes!,
            _selectedImageFileName!,
          );
          developer.log(
              '[InvTrack] Image uploaded for product ${widget.productId}',
              name: 'edit_product_page');
          setState(() {
            _isUploadingImage = false;
          });
        }

        final updatedProduct = Product(
          id: widget.productId,
          name: _nameController.text,
          serialNumber: _serialNumberController.text,
          category: _selectedCategory ?? widget.category,
          cost: double.parse(_costController.text),
          assignedTo: _assignedToController.text,
          notes: _notesController.text,
          imageUrl: newImageUrl!,
          createdAt: _currentProduct!.createdAt, // Keep original createdAt
          // updatedAt will be set by Firestore server timestamp
        );

        await firestoreService.updateProduct(updatedProduct);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Product updated successfully!'),
                backgroundColor: Colors.green),
          );
          developer.log('[InvTrack] Product updated: ${updatedProduct.name}',
              name: 'edit_product_page');
          context.pop();
        }
      } catch (e, s) {
        developer.log(
          '[InvTrack] Error updating product: $e',
          name: 'edit_product_page',
          error: e,
          stackTrace: s,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to update product: $e'),
                backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSavingProduct = false;
            _isUploadingImage = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: _isLoadingProduct
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        hintText: 'Enter product name',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _serialNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Serial Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        hintText: 'Enter serial number',
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Please enter a serial number'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a category' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _costController,
                      decoration: const InputDecoration(
                        labelText: 'Cost',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        hintText: 'Enter cost',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a cost';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _assignedToController,
                      decoration: const InputDecoration(
                        labelText: 'Assigned To',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        hintText: 'Enter assigned employee/location',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        hintText: 'Add any relevant notes',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    Text('Product Image', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.vertical(top: Radius.circular(12)),
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    color: Colors.grey[200],
                                    child: (_selectedImageBytes != null ||
                                            (_imageUrl != null &&
                                                _imageUrl!.isNotEmpty))
                                        ? Hero(
                                            tag:
                                                'product-image-${widget.productId}',
                                            child: (_selectedImageBytes != null
                                                ? Image.memory(
                                                    _selectedImageBytes!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    _imageUrl!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error, stackTrace) =>
                                                        const Center(
                                                            child: Text(
                                                                'Error loading image')),
                                                  )),
                                          )
                                        : const Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.camera_alt,
                                                    size: 40,
                                                    color: Colors.grey),
                                                Text('Tap to Pick Image'),
                                              ],
                                            ),
                                          ),
                                  ),
                                  if (_isPickingImage)
                                    const CircularProgressIndicator(),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedImageFileName ??
                                      (_imageUrl != null && _imageUrl!.isNotEmpty
                                          ? 'Existing Image'
                                          : 'No Image Selected'),
                                  style: theme.textTheme.bodyMedium,
                                ),
                                if (_selectedImageBytes != null || (_imageUrl != null && _imageUrl!.isNotEmpty))
                                  IconButton(
                                    icon: const Icon(Icons.cancel, color: Colors.red),
                                    onPressed: _clearSelectedImage,
                                    tooltip: 'Clear selected image',
                                  ),
                              ],
                            ),
                          ),
                          if (_isUploadingImage)
                            const LinearProgressIndicator(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _isSavingProduct ? null : _updateProduct,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      icon: _isSavingProduct
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        _isSavingProduct ? 'Updating Product...' : 'Update Product',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}