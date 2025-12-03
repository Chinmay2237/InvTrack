import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/auth_screen.dart';
import '../../features/orders/screens/order_screen.dart';
import '../../features/products/screens/product_detail_screen.dart';
import '../../features/products/screens/products_overview_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/wishlist/screens/wishlist_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
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
          ProductDetailScreen(productId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/orders',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const OrderScreen(),
        ),
      ),
      GoRoute(
        path: '/wishlist',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const WishlistScreen(),
        ),
      ),
      GoRoute(
        path: '/search',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const SearchScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const ProfileScreen(),
        ),
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
