import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:myapp/features/home/screens/home_screen.dart';
import 'package:myapp/features/dashboard/screens/dashboard_screen.dart';
import 'package:myapp/features/products/screens/products_overview_screen.dart';
import 'package:myapp/features/products/screens/product_detail_screen.dart';
import 'package:myapp/features/products/screens/product_form_screen.dart';
import 'package:myapp/features/settings/screens/settings_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => HomeScreen(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/products',
            builder: (context, state) => const ProductsOverviewScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => ProductDetailScreen(productId: state.pathParameters['id']!),
              ),
            ],
          ),
           GoRoute(
            path: '/add-product',
            builder: (context, state) => const ProductFormScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
