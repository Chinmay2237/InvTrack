import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:myapp/features/products/providers/product_provider.dart';
import 'package:myapp/features/products/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => context.go('/add-product'),
            tooltip: 'Add New Product',
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<ProductProvider>(
                  builder: (ctx, productData, child) => ListView.builder(
                    itemCount: productData.items.length,
                    itemBuilder: (_, i) => UserProductItem(
                      id: productData.items[i].id,
                      title: productData.items[i].name,
                      imageUrl: productData.items[i].imageUrl,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
