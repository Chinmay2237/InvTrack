import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<ProductProvider>(
      context,
      listen: false,
    ).getProductById(productId);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.name, style: const TextStyle(shadows: [Shadow(blurRadius: 8.0)])),
              background: Hero(
                tag: 'productImage-${loadedProduct.id}',
                child: Image.network(
                  loadedProduct.imageUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 150),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '\$${loadedProduct.price.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
              ),
              const SizedBox(height: 600), // Add extra space for scrolling effect
            ]),
          ),
        ],
      ),
    );
  }
}
