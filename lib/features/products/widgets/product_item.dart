import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../../wishlist/providers/wishlist_provider.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistProvider>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(
              wishlist.isFavorite(product.id) ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              wishlist.toggleWishlist(product);
            },
            tooltip: 'Toggle Favorite',
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {},
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          onTap: () => context.go('/product/${product.id}'),
          child: Image.network(
            product.imageUrl ?? '',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
