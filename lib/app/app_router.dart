import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/app/widgets/sidebar.dart';
import 'package:invtrack/core/services/auth_service.dart';
import 'package:invtrack/features/authentication/screens/login_screen.dart';
import 'package:invtrack/features/dashboard/screens/dashboard_screen.dart';
import 'package:invtrack/features/products/screens/add_product_page.dart';
import 'package:invtrack/features/products/screens/edit_product_page.dart';
import 'package:invtrack/features/products/screens/product_detail_page.dart';
import 'package:invtrack/features/products/screens/product_list_page.dart';
import 'package:provider/provider.dart';
import 'package:invtrack/features/csv/screens/csv_import_page.dart'; // Import the CsvImportPage

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter getRouter(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/', // Start at the root and let the redirect handle it
      refreshListenable: authService,
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return Sidebar(child: child);
          },
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DashboardScreen(),
            ),
            GoRoute(
              path: '/laptops',
              builder: (context, state) =>
                  const ProductListPage(category: 'Laptops'),
            ),
            GoRoute(
              path: '/mobiles',
              builder: (context, state) =>
                  const ProductListPage(category: 'Mobiles'),
            ),
            GoRoute(
              path: '/accessories',
              builder: (context, state) =>
                  const ProductListPage(category: 'Accessories'),
            ),
            GoRoute(
              path: '/furniture',
              builder: (context, state) =>
                  const ProductListPage(category: 'Furniture'),
            ),
            GoRoute(
              path: '/others',
              builder: (context, state) =>
                  const ProductListPage(category: 'Others'),
            ),
            GoRoute(
              path: '/csv-import', // New route for CSV import
              builder: (context, state) => const CsvImportPage(),
            ),
            GoRoute(
              path: '/:category/add',
              builder: (context, state) => AddProductPage(
                category: state.pathParameters['category']!,
              ),
            ),
            GoRoute(
              path: '/:category/edit/:id',
              builder: (context, state) => EditProductPage(
                category: state.pathParameters['category']!,
                productId: state.pathParameters['id']!,
              ),
            ),
            GoRoute(
              path: '/:category/details/:id',
              builder: (context, state) => ProductDetailPage(
                category: state.pathParameters['category']!,
                productId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final bool loggedIn = authService.isLoggedIn;
        final String location = state.matchedLocation;

        // Define authentication routes that unauthenticated users can access
        final isAuthRoute = location == '/login';

        // If the user is not logged in and not on an auth route, redirect to login
        if (!loggedIn && !isAuthRoute) {
          return '/login';
        }

        // If the user is logged in and trying to access the login page,
        // redirect them to the home page.
        if (loggedIn && location == '/login') {
          return '/';
        }

        // No redirect needed
        return null;
      },
    );
  }
}