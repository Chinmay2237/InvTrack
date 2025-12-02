import 'package:flutter/material.dart';
import 'package:workshop_demo/models/product.dart';

class ItemDetailsScreen extends StatelessWidget {
  final Product product;

  const ItemDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${product.description}'),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            Text('Stock: ${product.stock}'),
            Text('Category: ${product.category}'),
          ],
        ),
      ),
    );
  }
}
