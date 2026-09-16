import 'package:flutter/material.dart';
import '../theme/tokens.dart';

abstract class AppBottomSheet {
  /// Displays a custom, smooth bottom sheet with drag handle, rounded corners,
  /// and fluid enter/exit physics.
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    bool isDismissible = true,
    Color? backgroundColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? (isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTokens.radiusModal),
            ),
            boxShadow: isDark ? AppTokens.shadowModalDark : AppTokens.shadowModalLight,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Indicator Handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppTokens.textDisabledDark : AppTokens.textDisabledLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Flexible(child: builder(context)),
            ],
          ),
        );
      },
    );
  }
}
