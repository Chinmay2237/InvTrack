import 'package:flutter/material.dart';
import 'package:invtrack/features/products/models/product.dart';
import 'package:invtrack/ui/screens/products/widgets/product_grid_card.dart';
import 'package:invtrack/ui/screens/products/widgets/product_list_tile.dart';

class ProductListLayout extends StatelessWidget {
  final List<Product> products;
  final bool isGridView;

  const ProductListLayout({
    super.key,
    required this.products,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductGridCard(product: product);
        },
      );
    } else {
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductListTile(product: product);
        },
      );
    }
  }
}
