import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

/// Reusable Page Header enforcing strict single-primary-action hierarchy across InvTrack screens.
class AppPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final bool showSyncBadge;

  const AppPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.primaryAction,
    this.secondaryAction,
    this.showSyncBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 640;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showSyncBadge) ...[
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppTokens.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Live System Connected · Local SQLite',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppTokens.textSecondaryDark
                          : AppTokens.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.lora(
                          fontSize: isCompact ? 22 : 28,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppTokens.textPrimaryDark
                              : AppTokens.textPrimaryLight,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: isDark
                              ? AppTokens.textSecondaryDark
                              : AppTokens.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isCompact &&
                    (primaryAction != null || secondaryAction != null)) ...[
                  Row(
                    children: [
                      if (secondaryAction != null) ...[
                        secondaryAction!,
                        const SizedBox(width: 10),
                      ],
                      if (primaryAction != null) primaryAction!,
                    ],
                  ),
                ],
              ],
            ),
            if (isCompact &&
                (primaryAction != null || secondaryAction != null)) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  if (secondaryAction != null) ...[
                    Expanded(child: secondaryAction!),
                    const SizedBox(width: 8),
                  ],
                  if (primaryAction != null) Expanded(child: primaryAction!),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
