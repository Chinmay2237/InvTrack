import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'features/assign/providers/assign_provider.dart';
import 'providers/theme_provider.dart';
import 'features/products/providers/product_provider.dart';

import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/products/screens/products_overview_screen.dart';
import 'features/products/screens/product_detail_screen.dart';
import 'features/products/screens/product_form_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/assign/screens/assigns_screen.dart';
import 'features/assign/screens/assign_form_screen.dart';
import 'features/assign/screens/assigned_items_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => AssignProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Inventory Management',
            themeMode: themeProvider.themeMode,
            theme: _buildTheme(context, Brightness.light),
            darkTheme: _buildTheme(context, Brightness.dark),
            routerConfig: _router,
          );
        },
      ),
    );
  }
}

ThemeData _buildTheme(BuildContext context, Brightness brightness) {
  final baseTheme = ThemeData(
    primarySwatch: Colors.deepPurple,
    brightness: brightness,
    useMaterial3: true,
  );

  return baseTheme.copyWith(
    textTheme: baseTheme.textTheme.apply(fontFamily: 'Poppins'),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: brightness == Brightness.light ? Colors.grey.shade100 : Colors.grey.shade900,
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
      routes: [
        GoRoute(
          path: 'products',
          builder: (context, state) => const ProductsOverviewScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const ProductFormScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => ProductDetailScreen(productId: state.pathParameters['id']!),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => ProductFormScreen(productId: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'assign',
          builder: (context, state) => const AssignsScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const AssignFormScreen(),
            ),
            GoRoute(
              path: 'items',
              builder: (context, state) => const AssignedItemsScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
