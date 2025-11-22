
import 'package:flutter/material.dart';
import 'package:invtrack/core/services/auth_service.dart';
import 'package:invtrack/core/theme/modern_theme.dart';
import 'package:invtrack/features/authentication/screens/login_screen.dart';
import 'package:invtrack/features/home/screens/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  final authService = AuthService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider.value(value: authService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'InvTrack',
          theme: themeProvider.themeData,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(), // Start with the splash screen
          routes: {
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const HomePage(),
          },
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate loading
    if (mounted) {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (authService.currentUser != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2, color: Colors.white, size: 100),
            const SizedBox(height: 20),
            Text(
              'InvTrack',
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
