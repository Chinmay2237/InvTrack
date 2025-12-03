import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/products/screens/products_overview_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const ProductsOverviewScreen();
      },
    ),
  ],
);
