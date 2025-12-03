import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/core/theme/app_colors.dart';

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
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (assignedCount + unassignedCount) * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String label;
              if (groupIndex == 0) {
                label = 'Assigned';
              } else {
                label = 'Unassigned';
              }
              return BarTooltipItem(
                '$label\n${rod.toY.round()}',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
                String text;
                if (value.toInt() == 0) {
                  text = 'Assigned';
                } else if (value.toInt() == 1) {
                  text = 'Unassigned';
                } else {
                  return Container();
                }
                return SideTitleWidget(meta: meta,
                child: Text(text, style: style));
              },
              reservedSize: 32,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          _buildBarGroupData(0, assignedCount.toDouble(), AppColors.primary),
          _buildBarGroupData(1, unassignedCount.toDouble(), AppColors.lowStock),
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
          width: 22,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }
}
