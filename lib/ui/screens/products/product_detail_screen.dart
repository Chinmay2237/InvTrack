import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../features/products/models/product.dart';
import '../../../../features/products/providers/product_provider.dart';
import '../../../../features/products/screens/edit_product_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<ProductProvider>(context, listen: false).findById(productId);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 400.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.name, style: theme.appBarTheme.titleTextStyle),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => EditProductScreen(productId: product.id)));
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
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
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Icon(Icons.storage, color: product.quantity > 0 ? theme.colorScheme.secondary : theme.colorScheme.error, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${product.quantity} in stock',
                        style: theme.textTheme.displaySmall?.copyWith(color: product.quantity > 0 ? theme.colorScheme.secondary : theme.colorScheme.error, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    style: theme.textTheme.displaySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to remove this product from your inventory?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Provider.of<ProductProvider>(context, listen: false).deleteProduct(productId);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
