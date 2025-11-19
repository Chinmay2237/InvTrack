
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/core/services/firestore_service.dart';
import 'package:invtrack/features/products/models/product.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final String category;
  final String productId;
  const ProductDetailPage(
      {super.key, required this.category, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Future<void> _deleteProduct() async {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await firestoreService.deleteProduct(widget.productId);
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: FutureBuilder<Product>(
        future: firestoreService.getProductById(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final product = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${product.name}', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Category: ${product.category}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Quantity: ${product.quantity}'),
                const SizedBox(height: 8),
                Text('Price: \$${product.price.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                Text(product.description),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          context.go('/${widget.category}/edit/${widget.productId}'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _deleteProduct,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
