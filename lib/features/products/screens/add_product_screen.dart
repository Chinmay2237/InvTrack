import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:workshop_demo/features/products/providers/product_provider.dart';
import 'package:workshop_demo/features/products/widgets/product_form.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: ProductForm(
        onSubmit: (productData) {
          context.read<ProductProvider>().addProduct(productData);
          context.go('/');
        },
      ),
    );
  }
}
