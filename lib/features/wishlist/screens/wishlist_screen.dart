import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wishlist_provider.dart';
import '../../products/widgets/product_item.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistProvider>(context);
    final wishlistItems = wishlist.wishlistItems.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Wishlist'),
      ),
      body: wishlistItems.isEmpty
          ? const Center(
              child: Text(
                'Your wishlist is empty.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: wishlistItems.length,
              itemBuilder: (ctx, i) => ProductItem(
                product: wishlistItems[i],
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
    );
  }
}
