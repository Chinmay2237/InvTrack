import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:invtrack/core/services/firestore_service.dart';
import 'package:invtrack/features/products/models/product.dart';

class AddProductPage extends StatefulWidget {
  final String category;
  const AddProductPage({super.key, required this.category});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _costController = TextEditingController();
  final _assignedToController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedCategory;
  Uint8List? _imageData;
  String? _imageFileName;
  bool _isUploading = false;

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
    _selectedCategory = widget.category == "null" ? null : widget.category;
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _imageData = result.files.first.bytes;
        _imageFileName = result.files.first.name;
      });
      developer.log('[InvTrack] Image picked: $_imageFileName');
    }
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });
      final firestoreService =
          Provider.of<FirestoreService>(context, listen: false);
      String imageUrl = '';

      try {
        if (_imageData != null && _imageFileName != null) {
          imageUrl = await firestoreService.uploadProductImage(
                _serialNumberController.text, // Use serial number as unique ID for image path
                _imageData!,
                _imageFileName!,
              ) ??
              '';
          developer.log(
              '[InvTrack] Image uploaded for product ${_nameController.text}: $imageUrl');
        }

        final newProduct = Product(
          id: '', // Firestore will generate an ID
          name: _nameController.text,
          serialNumber: _serialNumberController.text,
          category: _selectedCategory!,
          cost: double.parse(_costController.text),
          assignedTo: _assignedToController.text,
          notes: _notesController.text,
          imageUrl: imageUrl,
          // createdAt and updatedAt will be handled by FirestoreService using FieldValue.serverTimestamp()
        );

        await firestoreService.addProduct(newProduct);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully!')),
          );
          developer.log('[InvTrack] Product added: ${_nameController.text}');
          context.pop();
        }
      } catch (e, s) {
        developer.log(
          '[InvTrack] Error adding product',
          error: e,
          stackTrace: s,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add product: $e')),
          );
        }
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'e.g., MacBook Pro 2023',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a product name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _serialNumberController,
                decoration: InputDecoration(
                  labelText: 'Serial Number',
                  hintText: 'e.g., ABC123DEF456',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a serial number' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  hintText: 'Select a category',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
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
                decoration: InputDecoration(
                  labelText: 'Cost',
                  hintText: 'e.g., 1200.00',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the cost';
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
                decoration: InputDecoration(
                  labelText: 'Assigned To',
                  hintText: 'e.g., John Doe / IT Department',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Any additional notes or remarks',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pick Image'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              if (_imageData != null) ...[
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
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
                        Image.memory(
                          _imageData!,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        Text(_imageFileName ?? 'No image selected'),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                  ),
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Add Product',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}