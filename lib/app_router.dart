import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workshop_demo/models/product.dart';
import 'package:workshop_demo/screens/edit_product_screen.dart';
import 'package:workshop_demo/screens/inventory_list_screen.dart';
import 'package:workshop_demo/screens/item_details_screen.dart';

class AppRouter {
  static const String inventory = '/';
  static const String itemDetails = '/item-details';
  static const String editProduct = '/edit-product';

  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: inventory,
        builder: (BuildContext context, GoRouterState state) {
          return const InventoryListScreen();
        },
      ),
      GoRoute(
        path: itemDetails,
        builder: (BuildContext context, GoRouterState state) {
          final product = state.extra as Product;
          return ItemDetailsScreen(product: product);
        },
      ),
      GoRoute(
        path: editProduct,
        builder: (BuildContext context, GoRouterState state) {
          final product = state.extra as Product?;
          return EditProductScreen(product: product);
        },
      ),
    ],
  );
}
