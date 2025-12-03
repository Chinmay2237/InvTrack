import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/product_provider.dart';
import '../widgets/product_form.dart';

class EditProductScreen extends StatelessWidget {
  final String productId;

  const EditProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final productToEdit = productProvider.getProductById(productId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: ProductForm(
        product: productToEdit,
        onSave: (product) {
          productProvider.updateProduct(product);
          context.pop();
        },
      ),
    );
  }
}
