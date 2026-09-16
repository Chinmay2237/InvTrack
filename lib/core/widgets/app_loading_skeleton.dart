import 'package:flutter/material.dart';
import '../theme/tokens.dart';

/// Skeleton loading placeholders for lists and cards.
class AppLoadingSkeleton extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const AppLoadingSkeleton({
    super.key,
    this.height = 20,
    this.width = double.infinity,
    this.borderRadius = AppTokens.radiusChip,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppTokens.surfaceAltDark : AppTokens.surfaceAltLight,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  static Widget listRows({int count = 4}) {
    return Column(
      children: List.generate(
        count,
        (index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: AppLoadingSkeleton(
              height: 54, borderRadius: AppTokens.radiusCard),
        ),
      ),
    );
  }
}
