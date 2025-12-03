import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_text.dart';
import 'package:myapp/core/theme/app_spacing.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.edgeInsetsAll16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppText.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                Icon(icon, color: color, size: 28),
              ],
            ),
            const SizedBox(height: AppSpacing.space8),
            Text(
              value,
              style: AppText.headlineMedium.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
