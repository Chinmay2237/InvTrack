import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/core/services/auth_service.dart';
import 'package:invtrack/core/services/firestore_service.dart';
import 'package:invtrack/core/theme/modern_theme.dart';
import 'package:invtrack/features/authentication/screens/login_screen.dart';
import 'package:invtrack/features/products/screens/add_product_page.dart';
import 'package:invtrack/features/products/screens/edit_product_page.dart';
import 'package:invtrack/features/products/screens/product_detail_page.dart';
import 'package:invtrack/ui/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:invtrack/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authService = AuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider.value(value: authService),
        Provider(create: (_) => FirestoreService()),
      ],
      child: MyApp(authService: authService),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  late final GoRouter _router;

  MyApp({super.key, required this.authService}) {
    _router = GoRouter(
      initialLocation: authService.isLoggedIn ? '/' : '/login',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/products/add',
          builder: (context, state) => const AddProductPage(),
        ),
        GoRoute(
          path: '/products/:id',
          builder: (context, state) => ProductDetailPage(
            productId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/products/:id/edit',
          builder: (context, state) => EditProductPage(
            productId: state.pathParameters['id']!,
          ),
        ),
      ],
      redirect: (context, state) {
        final bool loggedIn = authService.isLoggedIn;
        final bool loggingIn = state.matchedLocation == '/login';

        // If not logged in and not on the login page, redirect to the login page.
        if (!loggedIn && !loggingIn) {
          return '/login';
        }

        // If logged in and on the login page, redirect to the home page.
        if (loggedIn && loggingIn) {
          return '/';
        }

        // No redirect needed.
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'InvTrack',
          theme: themeProvider.themeData,
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
        );
      },
    );
  }
}
