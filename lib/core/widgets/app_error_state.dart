import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_icons.dart';
import '../theme/tokens.dart';
import 'app_buttons.dart';

/// iOS-styled Error Display Card widget with retry action.
class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppTokens.criticalSurfaceDark
            : AppTokens.criticalSurfaceLight,
        borderRadius: BorderRadius.circular(AppTokens.radiusCard),
        border: Border.all(
            color: AppTokens.critical.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(AppIcons.warning, color: AppTokens.critical, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTokens.critical,
                  ),
                ),
              ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: AppSecondaryButton(
                label: 'Retry',
                icon: AppIcons.refresh,
                onPressed: onRetry,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
