import 'package:flutter/material.dart';
import 'package:myapp/features/products/widgets/product_form.dart';


class EditProductScreen extends StatelessWidget {
  final String? productId;

  const EditProductScreen({super.key, this.productId});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: Text(productId == null ? 'Add New Product' : 'Edit Product'),
        elevation: 1,
      ),
      body: Center(
        child: SizedBox(
          width: isWeb ? 800 : double.infinity,
          child: ProductForm(productId: productId),
        ),
      ),
    );
  }
}
