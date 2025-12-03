import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../../../features/products/models/product.dart';
import '../../../../features/products/providers/product_provider.dart';
import '../../../../features/products/widgets/product_list_item.dart';

class ProductListLayout extends StatelessWidget {
  final bool isGridView;
  final String searchQuery;

  const ProductListLayout({
    super.key,
    required this.isGridView,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.items.where((p) {
      return p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    if (products.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
              const SizedBox(height: 24),
              Text(
                searchQuery.isEmpty ? 'No Products Yet' : 'No Results Found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                searchQuery.isEmpty
                    ? 'Tap \'+\' to add your first product.'
                    : 'Try a different search term.',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return isGridView
        ? _buildGridView(context, products)
        : _buildListView(context, products);
  }

  Widget _buildGridView(BuildContext context, List<Product> products) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300.0,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: (MediaQuery.of(context).size.width / 300).floor(),
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: ProductListItem(product: products[index]),
                ),
              ),
            );
          },
          childCount: products.length,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ProductListItem(product: products[index],),
                ),
              ),
            ),
          );
        },
        childCount: products.length,
      ),
    );
  }
}
