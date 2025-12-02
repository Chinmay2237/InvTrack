import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workshop_demo/features/products/models/product.dart';
import 'package:workshop_demo/features/products/screens/add_product_screen.dart';
import 'package:workshop_demo/features/products/screens/edit_product_screen.dart';
import 'package:workshop_demo/features/products/screens/product_detail_screen.dart';
import 'package:workshop_demo/features/products/screens/product_list_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ProductListScreen(),
    ),
    GoRoute(
      path: '/products/:id',
      builder: (context, state) => ProductDetailScreen(productId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/add-product',
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: '/products/:id/edit',
      builder: (context, state) {
        final product = state.extra as Product?;
        return product != null ? EditProductScreen(product: product) : const Text('Error: Product not found');
      },
    ),
  ],
);