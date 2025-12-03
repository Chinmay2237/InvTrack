import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_colors.dart';

enum StockStatus { inStock, outOfStock, lowStock }

class StockStatusTag extends StatelessWidget {
  final StockStatus status;
  final int quantity;

  const StockStatusTag({super.key, required this.status, required this.quantity});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String text;

    switch (status) {
      case StockStatus.inStock:
        color = AppColors.inStock;
        text = 'In Stock';
        break;
      case StockStatus.outOfStock:
        color = AppColors.outOfStock;
        text = 'Out of Stock';
        break;
      case StockStatus.lowStock:
        color = AppColors.lowStock;
        text = 'Low Stock';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: color, size: 10),
          const SizedBox(width: 6),
          Text(
            '$text ($quantity)',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
