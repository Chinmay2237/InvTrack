import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/dashboard/screens/dashboard_screen.dart';

import 'features/products/screens/add_product_screen.dart';
import 'features/products/screens/product_detail_screen.dart';
import 'features/products/screens/product_list_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const DashboardScreen();
        },
        routes: <GoRoute>[
          GoRoute(
            path: 'products',
            builder: (BuildContext context, GoRouterState state) {
              return const ProductListScreen();
            },
            routes: <GoRoute>[
              GoRoute(
                path: 'add',
                builder: (BuildContext context, GoRouterState state) {
                  return const AddProductScreen();
                },
              ),
              GoRoute(
                path: ':id',
                builder: (BuildContext context, GoRouterState state) {
                  final String id = state.pathParameters['id']!;
                  return ProductDetailScreen(productId: id);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
