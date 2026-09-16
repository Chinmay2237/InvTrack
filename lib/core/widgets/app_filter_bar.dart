import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

/// iOS Segmented Control / Filter Pill Bar component.
class AppFilterBar<T> extends StatelessWidget {
  final List<AppFilterOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  const AppFilterBar({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) {
          final isSelected = opt.value == selectedValue;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(opt.label),
              selected: isSelected,
              onSelected: (_) => onSelected(opt.value),
              selectedColor: isDark
                  ? AppTokens.primarySurfaceDark
                  : AppTokens.primarySurfaceLight,
              backgroundColor:
                  isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
              labelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppTokens.primary
                    : (isDark
                        ? AppTokens.textSecondaryDark
                        : AppTokens.textSecondaryLight),
              ),
              side: BorderSide(
                color: isSelected
                    ? AppTokens.primary
                    : (isDark ? AppTokens.borderDark : AppTokens.borderLight),
                width: isSelected ? 1.2 : 0.6,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTokens.radiusChip),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AppFilterOption<T> {
  final String label;
  final T value;

  const AppFilterOption({
    required this.label,
    required this.value,
  });
}
