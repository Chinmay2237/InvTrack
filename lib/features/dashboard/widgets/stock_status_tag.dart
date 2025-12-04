import 'package:flutter/material.dart';

enum StockStatus { inStock, lowStock, outOfStock }

class StockStatusTag extends StatelessWidget {
  final StockStatus status;
  final int quantity;

  const StockStatusTag({super.key, required this.status, required this.quantity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color color;
    final String label;

    switch (status) {
      case StockStatus.inStock:
        color = theme.colorScheme.secondary; // A positive, secondary color
        label = 'In Stock ($quantity)';
        break;
      case StockStatus.lowStock:
        color = Colors.orange; // A cautionary color
        label = 'Low Stock ($quantity)';
        break;
      case StockStatus.outOfStock:
        color = theme.colorScheme.error; // An error/alert color
        label = 'Out of Stock';
        break;
    }

    return Chip(
      label: Text(label, style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    );
  }
}
