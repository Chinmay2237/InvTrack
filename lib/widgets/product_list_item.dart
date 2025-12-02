import 'package:flutter/material.dart';
import 'package:workshop_demo/models/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductListItem({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text(product.description),
      trailing: Text('\$${product.price.toStringAsFixed(2)}'),
      onTap: onTap,
    );
  }
}
