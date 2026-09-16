import 'package:flutter/material.dart';
import '../theme/tokens.dart';

/// Grouped inset surface container inspired by Apple Settings & Reminders.
/// Wraps children in a rounded container with subtle border, surface background,
/// and automatic thin dividers between children.
class AppSurface extends StatelessWidget {
  final List<Widget>? children;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final Color? backgroundColor;

  const AppSurface({
    super.key,
    this.children,
    this.child,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.borderRadius = AppTokens.radiusGroup,
    this.backgroundColor,
  }) : assert(children != null || child != null,
            'Provide either child or children');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ??
        (isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight);
    final borderColor = isDark ? AppTokens.borderDark : AppTokens.borderLight;

    Widget content;
    if (children != null) {
      final divided = <Widget>[];
      for (int i = 0; i < children!.length; i++) {
        divided.add(children![i]);
        if (i < children!.length - 1) {
          divided.add(
            Divider(
              height: 0.5,
              thickness: 0.5,
              color: borderColor,
              indent: 16,
              endIndent: 16,
            ),
          );
        }
      }
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: divided,
      );
    } else {
      content = child!;
    }

    return Padding(
      padding: margin,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor,
            width: 0.5,
          ),
          boxShadow:
              isDark ? AppTokens.shadowCardDark : AppTokens.shadowCardLight,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius - 0.5),
          child: content,
        ),
      ),
    );
  }
}
