import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    return FutureBuilder<Product>(
      future: productProvider.getProductById(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Product Not Found'),
            ),
            body: const Center(
              child: Text('The requested product could not be found.'),
            ),
          );
        }

        final product = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(product.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.go('/products/${product.id}/edit'),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  productProvider.deleteProduct(product.id);
                  context.pop();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Product Details', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 16.0),
                        Text('Description: ${product.description}', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 8.0),
                        Text('Price: \$${product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 8.0),
                        Text('Quantity: ${product.quantity}', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
