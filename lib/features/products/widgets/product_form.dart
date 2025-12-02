import 'package:flutter/material.dart';
import 'package:workshop_demo/features/products/models/product.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final Function(Map<String, dynamic>) onSubmit;

  const ProductForm({super.key, this.product, required this.onSubmit});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _productData;

  @override
  void initState() {
    super.initState();
    _productData = widget.product != null
        ? {
            'name': widget.product!.name,
            'serialNumber': widget.product!.serialNumber,
            'category': widget.product!.category,
            'cost': widget.product!.cost,
            'price': widget.product!.price,
            'assignedTo': widget.product!.assignedTo,
            'notes': widget.product!.notes,
          }
        : {
            'name': '',
            'serialNumber': '',
            'category': '',
            'cost': 0.0,
            'price': 0.0,
            'assignedTo': '',
            'notes': '',
          };
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            initialValue: _productData['name'],
            decoration: const InputDecoration(labelText: 'Name'),
            onSaved: (value) => _productData['name'] = value,
          ),
          TextFormField(
            initialValue: _productData['serialNumber'],
            decoration: const InputDecoration(labelText: 'Serial Number'),
            onSaved: (value) => _productData['serialNumber'] = value,
          ),
          TextFormField(
            initialValue: _productData['category'],
            decoration: const InputDecoration(labelText: 'Category'),
            onSaved: (value) => _productData['category'] = value,
          ),
          TextFormField(
            initialValue: _productData['cost'].toString(),
            decoration: const InputDecoration(labelText: 'Cost'),
            keyboardType: TextInputType.number,
            onSaved: (value) => _productData['cost'] = double.tryParse(value ?? '0.0'),
          ),
          TextFormField(
            initialValue: _productData['price'].toString(),
            decoration: const InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
            onSaved: (value) => _productData['price'] = double.tryParse(value ?? '0.0'),
          ),
          TextFormField(
            initialValue: _productData['assignedTo'],
            decoration: const InputDecoration(labelText: 'Assigned To'),
            onSaved: (value) => _productData['assignedTo'] = value,
          ),
          TextFormField(
            initialValue: _productData['notes'],
            decoration: const InputDecoration(labelText: 'Notes'),
            maxLines: 3,
            onSaved: (value) => _productData['notes'] = value,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSubmit(_productData);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
