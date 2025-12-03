import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/core/theme/app_text.dart';

class StockStatusTag extends StatelessWidget {
  final int quantity;

  const StockStatusTag({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    Color textColor;

    if (quantity <= 0) {
      text = 'Out of Stock';
      color = AppColors.outOfStock;
      textColor = Colors.white;
    } else if (quantity < 10) {
      text = 'Low Stock';
      color = AppColors.lowStock;
      textColor = Colors.white;
    } else {
      text = 'In Stock';
      color = AppColors.inStock;
      textColor = Colors.white;
    }

    return Chip(
      label: Text(text, style: AppText.bodySmall.copyWith(color: textColor, fontWeight: FontWeight.bold)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}
