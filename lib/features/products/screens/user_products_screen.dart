import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../providers/product_provider.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          title: const Text('Your Products'),
                          actions: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => context.go('/edit-product'),
                              tooltip: 'Add New Product',
                            ),
                          ],
                          floating: true,
                          pinned: true,
                        ),
                        Consumer<ProductProvider>(
                          builder: (ctx, productsData, _) {
                            if (productsData.items.isEmpty) {
                              return SliverFillRemaining(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.business_center_outlined, size: 80, color: Colors.grey),
                                      const SizedBox(height: 24),
                                      Text(
                                        'No products found.',
                                        style: Theme.of(context).textTheme.headline6,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Add your first product to get started.',
                                        style: Theme.of(context).textTheme.bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return AnimationLimiter(
                              child: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) => AnimationConfiguration.staggeredList(
                                    position: i,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: UserProductItem(
                                          id: productsData.items[i].id,
                                          title: productsData.items[i].title,
                                          imageUrl: productsData.items[i].imageUrl ?? '',
                                        ),
                                      ),
                                    ),
                                  ),
                                  childCount: productsData.items.length,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
