import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assign_provider.dart';

class AssignFormScreen extends StatefulWidget {
  const AssignFormScreen({super.key});

  @override
  _AssignFormScreenState createState() => _AssignFormScreenState();
}

class _AssignFormScreenState extends State<AssignFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _productId = '';
  String _employeeId = '';
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Product ID'),
                onSaved: (value) => _productId = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Employee ID'),
                onSaved: (value) => _employeeId = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _quantity = int.parse(value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Provider.of<AssignProvider>(context, listen: false)
                        .assignProduct(_productId, _employeeId, _quantity);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Assign'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
