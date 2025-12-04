import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:myapp/features/products/models/product.dart';
import 'package:myapp/features/products/providers/product_provider.dart';
import 'package:myapp/ui/widgets/empty_state.dart';

class ProductListLayout extends StatelessWidget {
  final bool isGridView;
  final String searchQuery;
  final String category;

  const ProductListLayout({
    super.key,
    required this.isGridView,
    required this.searchQuery,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.items.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = category == 'All' || p.category == category;
      return matchesSearch && matchesCategory;
    }).toList();

    if (products.isEmpty) {
      return const SliverFillRemaining(
        child: EmptyState(
          icon: Icons.search_off_rounded,
          message: 'No products found.',
          suggestion: 'Try a different search or filter.',
        ),
      );
    }

    return isGridView
        ? _buildGridView(context, products)
        : _buildListView(context, products);
  }

  Widget _buildGridView(BuildContext context, List<Product> products) {
    final crossAxisCount = (MediaQuery.of(context).size.width / 200).floor();
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: crossAxisCount,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: _buildProductGridItem(context, products[index]),
                ),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildProductGridItem(BuildContext context, Product product) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.go('/product/${product.id}'),
        child: Stack(
          children: [
            Hero(
              tag: 'productImage${product.id}',
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 50)),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('\$${product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, List<Product> products) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: _buildProductListItem(context, products[index]),
                ),
              ),
            ),
          );
        },
        childCount: products.length,
      ),
    );
  }

  Widget _buildProductListItem(BuildContext context, Product product) {
    return Card(
      child: ListTile(
        onTap: () => context.go('/product/${product.id}'),
        leading: Hero(
          tag: 'productImage${product.id}',
          child: CircleAvatar(
            backgroundImage: NetworkImage(product.imageUrl),
            onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.image),
          ),
        ),
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(product.category),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$${product.price.toStringAsFixed(2)}'),
            Text('Qty: ${product.quantity}'),
          ],
        ),
      ),
    );
  }
}
