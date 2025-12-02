import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:workshop_demo/features/products/providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final product = provider.findById(productId);
        return Scaffold(
          appBar: AppBar(
            title: Text(product.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.go('/products/${product.id}/edit', extra: product),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<ProductProvider>().deleteProduct(product.id);
                  context.go('/');
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Serial Number: ${product.serialNumber}'),
              Text('Category: ${product.category}'),
              Text('Cost: \$${product.cost}'),
              Text('Price: \$${product.price}'),
              Text('Assigned To: ${product.assignedTo}'),
              const SizedBox(height: 10),
              Text('Notes: \n${product.notes}'),
            ],
          ),
        );
      },
    );
  }
}
