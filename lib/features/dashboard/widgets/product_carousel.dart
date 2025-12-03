import 'package:flutter/material.dart';
import 'package:myapp/features/products/models/product.dart';
import 'package:myapp/features/products/widgets/product_list_item.dart';

class ProductCarousel extends StatelessWidget {
  final String title;
  final List<Product> products;

  const ProductCarousel({super.key, required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: theme.textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SizedBox(
                  width: 180,
                  child: ProductListItem(product: products[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
