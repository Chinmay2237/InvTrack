
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workshop_demo/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: Text('\$${product.price.toStringAsFixed(2)}'),
        onTap: () {
          context.go('/product/${product.id}', extra: product);
        },
      ),
    );
  }
}
