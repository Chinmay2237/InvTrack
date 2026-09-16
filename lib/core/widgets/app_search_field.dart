import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_icons.dart';
import '../theme/tokens.dart';

/// iOS-styled search bar input component with clear button.
class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const AppSearchField({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: isDark ? AppTokens.surfaceAltDark : AppTokens.surfaceAltLight,
        borderRadius: BorderRadius.circular(AppTokens.radiusInput),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color:
              isDark ? AppTokens.textPrimaryDark : AppTokens.textPrimaryLight,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          prefixIcon: Icon(
            AppIcons.search,
            size: 16,
            color: isDark
                ? AppTokens.textSecondaryDark
                : AppTokens.textSecondaryLight,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  tooltip: 'Clear search text',
                  icon: Icon(
                    AppIcons.close,
                    size: 16,
                    color: isDark
                        ? AppTokens.textSecondaryDark
                        : AppTokens.textSecondaryLight,
                  ),
                  onPressed: () {
                    controller.clear();
                    if (onChanged != null) onChanged!('');
                    if (onClear != null) onClear!();
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
