import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/features/products/models/product.dart';

class CategoryBarChart extends StatelessWidget {
  final List<Product> products;

  const CategoryBarChart({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryCounts = _getCategoryCounts();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: categoryCounts.values.fold<double>(0, (max, v) => v > max ? v : max) * 1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final category = categoryCounts.keys.elementAt(groupIndex);
              return BarTooltipItem(
                '$category\n',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                    text: rod.toY.round().toString(),
                    style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
          touchCallback: (FlTouchEvent event, barTouchResponse) {},
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final category = categoryCounts.keys.elementAt(value.toInt());
                return SideTitleWidget(
                  meta: meta,
                  space: 8.0,
                  child: Text(category, style: theme.textTheme.bodySmall),
                );
              },
              reservedSize: 38,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _generateBarGroups(categoryCounts),
        gridData: const FlGridData(show: false),
      ),
    );
  }

  Map<String, double> _getCategoryCounts() {
    final Map<String, double> categoryCounts = {};
    for (var product in products) {
      categoryCounts.update(product.category, (value) => value + 1, ifAbsent: () => 1);
    }
    return categoryCounts;
  }

  List<BarChartGroupData> _generateBarGroups(Map<String, double> categoryCounts) {
    return List.generate(categoryCounts.length, (index) {
      final category = categoryCounts.keys.elementAt(index);
      final value = categoryCounts[category]!;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: AppColors.primary,
            width: 22,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    });
  }
}
