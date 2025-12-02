import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop_demo/models/product.dart';
import 'package:workshop_demo/providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product? product;

  const EditProductScreen({super.key, this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late double _price;
  late int _stock;
  late String _category;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _name = widget.product!.name;
      _description = widget.product!.description;
      _price = widget.product!.price;
      _stock = widget.product!.stock;
      _category = widget.product!.category;
    } else {
      _name = '';
      _description = '';
      _price = 0.0;
      _stock = 0;
      _category = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProductForm(
          formKey: _formKey,
          name: _name,
          description: _description,
          price: _price,
          stock: _stock,
          category: _category,
          onSaved: (name, description, price, stock, category) {
            _name = name;
            _description = description;
            _price = price;
            _stock = stock;
            _category = category;
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            final productProvider = Provider.of<ProductProvider>(context, listen: false);
            if (widget.product == null) {
              productProvider.addProduct(
                Product(
                  id: DateTime.now().toString(),
                  name: _name,
                  description: _description,
                  price: _price,
                  stock: _stock,
                  category: _category, lastUpdated: DateTime.now(),
                ),
              );
            } else {
              productProvider.updateProduct(
                Product(
                  id: widget.product!.id,
                  name: _name,
                  description: _description,
                  price: _price,
                  stock: _stock,
                  category: _category, lastUpdated: DateTime.now(),
                ),
              );
            }
            Navigator.of(context).pop();
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class ProductForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final Function(String, String, double, int, String) onSaved;

  const ProductForm({
    super.key,
    required this.formKey,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: name,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
            onSaved: (value) => onSaved(value!, description, price, stock, category),
          ),
          TextFormField(
            initialValue: description,
            decoration: const InputDecoration(labelText: 'Description'),
            validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
            onSaved: (value) => onSaved(name, value!, price, stock, category),
          ),
          TextFormField(
            initialValue: price.toString(),
            decoration: const InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
            onSaved: (value) => onSaved(name, description, double.parse(value!), stock, category),
          ),
          TextFormField(
            initialValue: stock.toString(),
            decoration: const InputDecoration(labelText: 'Stock'),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'Please enter the stock' : null,
            onSaved: (value) => onSaved(name, description, price, int.parse(value!), category),
          ),
          TextFormField(
            initialValue: category,
            decoration: const InputDecoration(labelText: 'Category'),
            validator: (value) => value!.isEmpty ? 'Please enter a category' : null,
            onSaved: (value) => onSaved(name, description, price, stock, value!),
          ),
        ],
      ),
    );
  }
}
