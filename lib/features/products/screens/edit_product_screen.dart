
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:workshop_demo/models/product.dart';
import 'package:workshop_demo/providers/product_provider.dart';
import 'package:workshop_demo/widgets/product_form.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: ProductForm(
        product: product,
        onSubmit: (productData) async {
          await context.read<ProductProvider>().updateProduct(product.id, productData);
          if (context.mounted) {
            context.go('/');
          }
        },
      ),
    );
  }
}
