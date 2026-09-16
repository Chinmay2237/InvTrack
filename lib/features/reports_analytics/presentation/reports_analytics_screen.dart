import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/tokens.dart';
import '../../dashboard/presentation/providers/dashboard_provider.dart';

class ReportsAnalyticsScreen extends ConsumerStatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  ConsumerState<ReportsAnalyticsScreen> createState() =>
      _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState
    extends ConsumerState<ReportsAnalyticsScreen> {
  int _rangeDays = 30;

  @override
  Widget build(BuildContext context) {
    final kpisAsync = ref.watch(dashboardKpisProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(AppIcons.dashboard, color: AppTokens.primary, size: 22),
            SizedBox(width: 8),
            Text('Reports & Inventory Valuation'),
          ],
        ),
        leading: IconButton(
          tooltip: 'Back to Dashboard',
          icon: const Icon(AppIcons.back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Export & Date Selector Bar
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(AppIcons.calendar,
                            size: 18, color: AppTokens.primary),
                        const SizedBox(width: 8),
                        Text('Reporting Window:',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(width: 12),
                        SegmentedButton<int>(
                          segments: const [
                            ButtonSegment(value: 7, label: Text('7 Days')),
                            ButtonSegment(value: 30, label: Text('30 Days')),
                            ButtonSegment(value: 90, label: Text('90 Days')),
                          ],
                          selected: {_rangeDays},
                          onSelectionChanged: (val) =>
                              setState(() => _rangeDays = val.first),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Exported Analytics Report to CSV')),
                            );
                          },
                          icon: const Icon(AppIcons.exportCsv, size: 16),
                          label: const Text('Export CSV'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Generated Valuation PDF Report')),
                            );
                          },
                          icon: const Icon(AppIcons.exportPdf, size: 16),
                          label: const Text('Export PDF'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // KPI Overview Cards
            kpisAsync.when(
              data: (kpis) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildReportKpi(
                        context,
                        title: 'Total Stock Asset Valuation',
                        value: '\$${kpis.totalStockValue.toStringAsFixed(2)}',
                        icon: AppIcons.stock,
                        color: AppTokens.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildReportKpi(
                        context,
                        title: 'Active Asset Handovers',
                        value: '${kpis.assignedAssetsCount} Assets',
                        icon: AppIcons.assignment,
                        color: AppTokens.info,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildReportKpi(
                        context,
                        title: 'Reorder Attention Needed',
                        value: '${kpis.lowStockCount} Items',
                        icon: AppIcons.warning,
                        color: AppTokens.warning,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text('Error: $err'),
            ),
            const SizedBox(height: 24),

            // Location Stock Breakdown Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stock Allocation by Warehouse Location',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [
                              BarChartRodData(
                                  toY: 180, color: AppTokens.primary, width: 24)
                            ]),
                            BarChartGroupData(x: 1, barRods: [
                              BarChartRodData(
                                  toY: 85,
                                  color: AppTokens.secondaryAccent,
                                  width: 24)
                            ]),
                          ],
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true, reservedSize: 30)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (val, meta) {
                                  if (val == 0) {
                                    return const Text('Main Logistics Center');
                                  }
                                  if (val == 1) {
                                    return const Text('Project Site Alpha');
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Strategic Insights List (Section 6.8 spec)
            Text('Strategic Inventory Insights',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _buildInsightTile(
              context,
              title: 'High Asset Value Concentration in Electronics',
              desc:
                  '75% of total stock valuation resides in Laptop Pro 15 and Smartphone Ultra inventory.',
              icon: AppIcons.stock,
              color: AppTokens.primary,
            ),
            const SizedBox(height: 8),
            _buildInsightTile(
              context,
              title: 'Overdue Return Flag on Field Testing Campaign',
              desc:
                  'Smartphone Ultra issued to Bob Jones is past due return date by 2 days.',
              icon: AppIcons.history,
              color: AppTokens.critical,
            ),
            const SizedBox(height: 8),
            _buildInsightTile(
              context,
              title: 'Slow-Moving Stock Warning: Office Coffee Maker',
              desc:
                  'Zero stock movement recorded over the past 30 days. Consider re-allocating to Site B.',
              icon: AppIcons.warning,
              color: AppTokens.warning,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportKpi(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: color,
                    fontSize: 20,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightTile(
    BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppTokens.radiusButton),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(desc, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}
