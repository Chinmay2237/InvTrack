import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_icons.dart';
import '../theme/tokens.dart';
import 'pressable_scale.dart';

/// iOS Settings/Reminders style list item row with leading icon tile,
/// title, subtitle, trailing widget/chevron, and press scale feedback.
class AppListRow extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;
  final EdgeInsetsGeometry padding;

  const AppListRow({
    super.key,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showChevron = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget? leadingWidget = leading;
    if (leadingWidget == null && icon != null) {
      final bg = iconBackgroundColor ??
          (isDark
              ? AppTokens.primarySurfaceDark
              : AppTokens.primarySurfaceLight);
      final fg = iconColor ?? AppTokens.primary;
      leadingWidget = Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: fg),
      );
    }

    final rowContent = Padding(
      padding: padding,
      child: Row(
        children: [
          if (leadingWidget != null) ...[
            leadingWidget,
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppTokens.textPrimaryDark
                        : AppTokens.textPrimaryLight,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: isDark
                          ? AppTokens.textSecondaryDark
                          : AppTokens.textSecondaryLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
          if (showChevron) ...[
            const SizedBox(width: 8),
            Icon(
              AppIcons.forward,
              size: 18,
              color: isDark
                  ? AppTokens.textDisabledDark
                  : AppTokens.textDisabledLight,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return rowContent;

    return PressableScale(
      onTap: onTap,
      child: rowContent,
    );
  }
}
