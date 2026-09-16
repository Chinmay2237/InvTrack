import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/tokens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Navigate to Dashboard after splash initialization
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTokens.backgroundDark : AppTokens.backgroundLight,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo Container
                Container(
                  width: 120,
                  height: 120,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark ? AppTokens.borderDark : AppTokens.borderLight,
                      width: 1.5,
                    ),
                    boxShadow: isDark ? AppTokens.shadowModalDark : AppTokens.shadowModalLight,
                  ),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.inventory_2_rounded,
                        size: 56,
                        color: AppTokens.primary,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // App Title
                Text(
                  'InvTrack v2',
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTokens.textPrimaryDark : AppTokens.textPrimaryLight,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),

                // App Subtitle
                Text(
                  'Commercial Asset & Warehouse Studio',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    color: isDark ? AppTokens.textSecondaryDark : AppTokens.textSecondaryLight,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 48),

                // Loading Status & Spinner
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTokens.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
