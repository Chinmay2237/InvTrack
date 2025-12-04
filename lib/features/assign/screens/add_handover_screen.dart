import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/features/assign/providers/assign_provider.dart';
import 'package:myapp/features/products/providers/product_provider.dart';
import 'package:myapp/features/products/models/product.dart';
import 'package:myapp/features/assign/models/handover_type.dart';

class AddHandoverScreen extends StatefulWidget {
  const AddHandoverScreen({super.key});

  @override
  State<AddHandoverScreen> createState() => _AddHandoverScreenState();
}

class _AddHandoverScreenState extends State<AddHandoverScreen> {
  final _formKey = GlobalKey<FormState>();
  Product? _selectedProduct;
  String _employeeName = '';
  HandoverType _handoverType = HandoverType.Permanent;
  String? _projectName;
  var _isLoading = false;

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product.')),
      );
      return;
    }

    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    try {
      Provider.of<AssignProvider>(context, listen: false).assignProduct(
        _selectedProduct!,
        _employeeName,
        _handoverType,
        projectName: _projectName,
      );
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
    final products = Provider.of<ProductProvider>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Handover'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt_rounded),
            onPressed: _saveForm,
            tooltip: 'Save Handover',
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
                      Text('Handover Details', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      _buildProductDropdown(context, products),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        context: context,
                        labelText: 'Employee Name',
                        icon: Icons.person_outline,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please enter an employee name.' : null,
                        onSaved: (value) => _employeeName = value!,
                      ),
                      const SizedBox(height: 16),
                      _buildHandoverTypeDropdown(context),
                      if (_handoverType == HandoverType.Temporary)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: _buildTextFormField(
                            context: context,
                            labelText: 'Project Name',
                            icon: Icons.business_center_outlined,
                            onSaved: (value) => _projectName = value,
                          ),
                        ),
                      const SizedBox(height: 32),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add_task_rounded),
                          label: const Text('Add Handover'),
                          onPressed: _saveForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            textStyle: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildProductDropdown(BuildContext context, List<Product> products) {
    return DropdownButtonFormField<Product>(
      value: _selectedProduct,
      hint: const Text('Select a Product'),
      items: products.map((product) {
        return DropdownMenuItem<Product>(
          value: product,
          child: Text(product.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedProduct = value;
        });
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.inventory_2_outlined),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) => (value == null) ? 'Please select a product.' : null,
    );
  }

  Widget _buildHandoverTypeDropdown(BuildContext context) {
    return DropdownButtonFormField<HandoverType>(
      value: _handoverType,
      items: HandoverType.values.map((type) {
        return DropdownMenuItem<HandoverType>(
          value: type,
          child: Text(type.toString().split('.').last),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _handoverType = value!;
        });
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.transfer_within_a_station_outlined),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required BuildContext context,
    required String labelText,
    required IconData icon,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      textInputAction: TextInputAction.next,
    );
  }
}
