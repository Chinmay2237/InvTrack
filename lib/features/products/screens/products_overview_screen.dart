import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/product_grid.dart';
import '../../../core/widgets/app_drawer.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Open Wishlist',
            onPressed: () {
              context.go('/wishlist');
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<ProductProvider>(context, listen: false)
            .fetchAndSetProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('An error occurred!'));
          } else {
            return const ProductsGrid(showFavs: false);
          }
        },
      ),
    );
  }
}
