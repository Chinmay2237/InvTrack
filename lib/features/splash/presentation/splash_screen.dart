import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/track_loop_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.7, curve: Curves.easeOut)),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.3, 1.0, curve: Curves.easeInOut)),
    );

    _controller.forward();

    // Navigate to Dashboard after splash initialization
    Future.delayed(const Duration(milliseconds: 1700), () {
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
      backgroundColor:
          isDark ? AppTokens.backgroundDark : AppTokens.backgroundLight,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Minimal Track Loop Logo Mark (No big card box)
                const TrackLoopLogo(
                  size: 76,
                  showBadge: false,
                ),
                const SizedBox(height: 24),

                // Product Title
                Text(
                  'InvTrack',
                  style: GoogleFonts.lora(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: isDark
                        ? AppTokens.textPrimaryDark
                        : AppTokens.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 6),

                // Product Tagline / Descriptor
                Text(
                  'Inventory, without the friction.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: isDark
                        ? AppTokens.textSecondaryDark
                        : AppTokens.textSecondaryLight,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 44),

                // Understated Animated Horizontal Progress Line
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 120,
                      height: 3,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTokens.borderDark.withValues(alpha: 0.4)
                            : AppTokens.borderLight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: _progressAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTokens.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
