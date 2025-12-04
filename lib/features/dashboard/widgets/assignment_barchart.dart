import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AssignmentBarChart extends StatelessWidget {
  final int assignedCount;
  final int unassignedCount;

  const AssignmentBarChart({
    super.key,
    required this.assignedCount,
    required this.unassignedCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final assignedColor = theme.colorScheme.primary;
    final unassignedColor = theme.colorScheme.secondary;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (assignedCount + unassignedCount) * 1.4, // Increased maxY for better spacing
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final label = groupIndex == 0 ? 'Assigned' : 'Unassigned';
              return BarTooltipItem(
                '$label\n${rod.toY.round()}',
                TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta title) {
                final style = theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold);
                String text;
                if (value.toInt() == 0) {
                  text = 'Assigned';
                } else if (value.toInt() == 1) {
                  text = 'Unassigned';
                } else {
                  return Container();
                }
                return SideTitleWidget(
                  axisSide: title.axisSide,
                  space: 4,
                  child: Text(text, style: style),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          _buildBarGroupData(0, assignedCount.toDouble(), assignedColor),
          _buildBarGroupData(1, unassignedCount.toDouble(), unassignedColor),
        ],
        gridData: const FlGridData(show: false),
      ),
    );
  }

  BarChartGroupData _buildBarGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 25, // Slightly wider bars
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}
