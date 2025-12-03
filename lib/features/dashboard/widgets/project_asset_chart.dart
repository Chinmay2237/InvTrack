import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/core/theme/app_text.dart';

class ProjectAssetChart extends StatelessWidget {
  final Map<String, int> projectAssetCounts;

  const ProjectAssetChart({super.key, required this.projectAssetCounts});

  @override
  Widget build(BuildContext context) {
    final List<BarChartGroupData> barGroups = [];
    final List<String> projectNames = projectAssetCounts.keys.toList();

    for (int i = 0; i < projectNames.length; i++) {
      final projectName = projectNames[i];
      final assetCount = projectAssetCounts[projectName]!;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: assetCount.toDouble(),
              color: AppColors.primary,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: projectAssetCounts.values.fold<int>(0, (max, v) => v > max ? v : max).toDouble() + 2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.toY.round().toString(),
                AppText.bodyMedium.copyWith(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() % 2 == 0) {
                  return Text(value.toInt().toString(), style: AppText.bodySmall);
                }
                return const SizedBox();
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < projectNames.length) {
                  return SideTitleWidget(
                    meta: meta,
                    // axisSide: meta.axisSide,
                    child: Text(
                      projectNames[index],
                      style: AppText.bodySmall,
                    ),
                  );
                }
                return const SizedBox();
              },
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.borderColor.withOpacity(0.5),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: barGroups,
      ),
    );
  }
}
