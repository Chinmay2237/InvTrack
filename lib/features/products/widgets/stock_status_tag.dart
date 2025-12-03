import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_colors.dart';

class StockStatusTag extends StatelessWidget {
  final int quantity;

  const StockStatusTag({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    if (quantity <= 0) {
      text = 'Out of Stock';
      color = AppColors.outOfStock;
    } else if (quantity < 10) {
      text = 'Low Stock';
      color = AppColors.lowStock;
    } else {
      text = 'In Stock';
      color = AppColors.inStock;
    }

    return Chip(
      label: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}
