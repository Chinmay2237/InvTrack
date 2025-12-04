import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../products/providers/product_provider.dart';
import '../../products/models/product.dart';
import '../providers/assign_provider.dart';

class AssignFormScreen extends StatefulWidget {
  const AssignFormScreen({super.key});

  @override
  _AssignFormScreenState createState() => _AssignFormScreenState();
}

class _AssignFormScreenState extends State<AssignFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProductId;
  String? _selectedEmployeeId;
  int _quantity = 1;

  // Placeholder for employee data
  final List<Map<String, String>> _employees = [
    {'id': 'E1', 'name': 'Alice'},
    {'id': 'E2', 'name': 'Bob'},
    {'id': 'E3', 'name': 'Charlie'},
    {'id': 'E4', 'name': 'Diana'},
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_selectedProductId != null && _selectedEmployeeId != null) {
        Provider.of<AssignProvider>(context, listen: false)
            .assignProduct(_selectedProductId!, _selectedEmployeeId!, _quantity);
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a product and an employee.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final products = Provider.of<ProductProvider>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Product'),
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
              _buildCard([
                _buildProductDropdown(products),
                const SizedBox(height: 16),
                _buildEmployeeDropdown(),
                const SizedBox(height: 16),
                _buildTextFormField(
                  initialValue: _quantity.toString(),
                  labelText: 'Quantity',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (int.tryParse(value!) == null || int.parse(value) <= 0) {
                      return 'Enter a valid quantity';
                    }
                    return null;
                  },
                  onSaved: (value) => _quantity = int.parse(value!),
                ),
              ]),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.assignment_turned_in_outlined),
                label: const Text('Assign Product'),
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

  Widget _buildProductDropdown(List<Product> products) {
    return DropdownButtonFormField<String>(
      value: _selectedProductId,
      decoration: const InputDecoration(
        labelText: 'Select Product',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        filled: true,
      ),
      items: products.map((product) {
        return DropdownMenuItem(
          value: product.id,
          child: Text(product.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedProductId = value;
        });
      },
      validator: (value) => value == null ? 'Please select a product' : null,
    );
  }

   Widget _buildEmployeeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedEmployeeId,
      decoration: const InputDecoration(
        labelText: 'Select Employee',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        filled: true,
      ),
      items: _employees.map((employee) {
        return DropdownMenuItem(
          value: employee['id'],
          child: Text(employee['name']!),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedEmployeeId = value;
        });
      }, 
      validator: (value) => value == null ? 'Please select an employee' : null,
    );
  }

  Widget _buildTextFormField({
    String? initialValue,
    required String labelText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
