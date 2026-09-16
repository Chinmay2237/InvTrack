import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';
import 'app_status_badge.dart';
import 'pressable_scale.dart';

/// Specialty handover / movement activity row component.
class AppActivityRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String employeeName;
  final String status;
  final String? assignmentType;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const AppActivityRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.employeeName,
    required this.status,
    this.assignmentType,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = employeeName
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    final isPerm = assignmentType == 'permanent';

    final content = Padding(
      padding: padding,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isPerm
                ? (isDark
                    ? AppTokens.primarySurfaceDark
                    : AppTokens.primarySurfaceLight)
                : (isDark
                    ? AppTokens.infoSurfaceDark
                    : AppTokens.infoSurfaceLight),
            child: Text(
              initials,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isPerm ? AppTokens.primary : AppTokens.info,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppTokens.textPrimaryDark
                              : AppTokens.textPrimaryLight,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (assignmentType != null) ...[
                      const SizedBox(width: 6),
                      AppStatusBadge(status: assignmentType!, isCompact: true),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark
                        ? AppTokens.textSecondaryDark
                        : AppTokens.textSecondaryLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          AppStatusBadge(status: status),
        ],
      ),
    );

    if (onTap == null) return content;

    return PressableScale(
      onTap: onTap,
      child: content,
    );
  }
}
