
import 'package:go_router/go_router.dart';
import 'package:workshop_demo/features/products/screens/add_product_screen.dart';
import 'package:workshop_demo/features/products/screens/edit_product_screen.dart';
import 'package:workshop_demo/features/products/screens/product_detail_screen.dart';
import 'package:workshop_demo/features/products/screens/product_list_screen.dart';
import 'package:workshop_demo/models/product.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductListScreen(),
        routes: [
          GoRoute(
            path: 'product/:id',
            builder: (context, state) {
              final product = state.extra as Product?;
              if (product != null) {
                return ProductDetailScreen(product: product);
              } else {
                // Handle the case where the product is not passed
                // You might want to fetch it from the provider based on the id
                return const ProductListScreen();
              }
            },
          ),
          GoRoute(
            path: 'add-product',
            builder: (context, state) => const AddProductScreen(),
          ),
          GoRoute(
            path: 'edit-product',
            builder: (context, state) {
              final product = state.extra as Product?;
              if (product != null) {
                return EditProductScreen(product: product);
              } else {
                return const ProductListScreen();
              }
            },
          ),
        ],
      ),
    ],
  );
}
