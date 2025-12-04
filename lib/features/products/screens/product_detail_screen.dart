import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:myapp/features/products/models/product.dart';
import 'package:myapp/features/products/providers/product_provider.dart';
import 'package:myapp/features/dashboard/widgets/stock_status_tag.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final Product product = productProvider.findById(productId);
        final status = product.quantity == 0
            ? StockStatus.outOfStock
            : product.quantity <= 10
                ? StockStatus.lowStock
                : StockStatus.inStock;

        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 400.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 12.0),
                  title: Text(
                    product.name,
                    style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  background: Hero(
                    tag: product.id,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    tooltip: 'Delete Product',
                    onPressed: () => _showDeleteConfirmationDialog(context, product.id),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          StockStatusTag(status: status, quantity: product.quantity),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Description',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to remove this product from your inventory? This action cannot be undone.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
            onPressed: () {
              Provider.of<ProductProvider>(context, listen: false).deleteProduct(productId);
              Navigator.of(ctx).pop(); // Close the dialog
              context.pop(); // Go back from the detail screen
            },
          ),
        ],
      ),
    );
  }
}
