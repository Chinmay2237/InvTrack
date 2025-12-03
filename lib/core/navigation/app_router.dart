import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/products/screens/edit_product_screen.dart';
import '../../features/products/screens/product_detail_screen.dart';
import '../../features/products/screens/products_overview_screen.dart';
import '../../features/products/screens/user_products_screen.dart';

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    refreshListenable: authProvider,
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const ProductsOverviewScreen(),
        ),
      ),
      GoRoute(
        path: '/product/:id',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          ProductDetailScreen(productId: state.pathParameters['id']!,),
        ),
      ),
      
     
      GoRoute(
        path: '/user-products',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const UserProductsScreen(),
        ),
      ),
      GoRoute(
        path: '/edit-product',
        pageBuilder: (context, state) {
          final productId = state.uri.queryParameters['id'];
          return _buildPageWithFadeTransition(
            context,
            state,
            EditProductScreen(productId: productId),
          );
        },
      ),
    
      GoRoute(
        path: '/auth',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const AuthScreen(),
        ),
      ),
    ],
  );

  static CustomTransitionPage _buildPageWithFadeTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
