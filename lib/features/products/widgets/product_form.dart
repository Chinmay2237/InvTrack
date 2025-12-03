import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;

  const ProductForm({super.key, this.product, required this.onSave});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  late String _name;
  late String _description;
  late double _price;
  late int _quantity;
  String? _category;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _id = widget.product?.id ?? '';
    _name = widget.product?.name ?? '';
    _description = widget.product?.description ?? '';
    _price = widget.product?.price ?? 0.0;
    _quantity = widget.product?.quantity ?? 0;
    _category = widget.product?.category;
    _imageUrl = widget.product?.imageUrl;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSave(
        Product(
          id: _id,
          name: _name,
          description: _description,
          price: _price,
          quantity: _quantity,
          category: _category,
          imageUrl: _imageUrl,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              initialValue: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              onSaved: (value) => _description = value!,
            ),
            TextFormField(
              initialValue: _price.toString(),
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || double.tryParse(value) == null) {
                  return 'Please enter a valid price';
                }
                return null;
              },
              onSaved: (value) => _price = double.parse(value!),
            ),
            TextFormField(
              initialValue: _quantity.toString(),
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || int.tryParse(value) == null) {
                  return 'Please enter a valid quantity';
                }
                return null;
              },
              onSaved: (value) => _quantity = int.parse(value!),
            ),
            TextFormField(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              onSaved: (value) => _category = value,
            ),
            TextFormField(
              initialValue: _imageUrl,
              decoration: const InputDecoration(labelText: 'Image URL'),
              onSaved: (value) => _imageUrl = value,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveForm,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
