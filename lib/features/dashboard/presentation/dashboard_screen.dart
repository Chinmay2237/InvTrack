import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/database/database.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/tokens.dart';
import '../../inventory/domain/entities/item_entity.dart';
import '../../inventory/presentation/providers/inventory_provider.dart';
import '../../handovers/presentation/providers/handover_provider.dart';
import 'providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _trendDays = 7;

  @override
  Widget build(BuildContext context) {
    final kpisAsync = ref.watch(dashboardKpisProvider);
    final handoversAsync = ref.watch(handoversListProvider);
    final itemsAsync = ref.watch(itemsStreamProvider);
    final employeesAsync = ref.watch(employeesListProvider);

    final itemsMap = itemsAsync.maybeWhen(
      data: (items) => {for (var i in items) i.id: i},
      orElse: () => <String, ItemEntity>{},
    );

    final employeesMap = employeesAsync.maybeWhen(
      data: (emps) => {for (var e in emps) e.id: e},
      orElse: () => <String, Employee>{},
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTokens.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(AppIcons.inventoryActive,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('InvTrack Dashboard'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.category),
            tooltip: 'Reports & Analytics',
            onPressed: () => context.go('/reports'),
          ),
          IconButton(
            icon: const Icon(AppIcons.handovers),
            tooltip: 'Stock Movement Ledger',
            onPressed: () => context.go('/stock-movements'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Cards Row
            kpisAsync.when(
              data: (kpis) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildKpiCard(
                                  context,
                                  title: 'Total Stock Value',
                                  value:
                                      '\$${kpis.totalStockValue.toStringAsFixed(2)}',
                                  icon: AppIcons.stock,
                                  color: AppTokens.primary,
                                  bgColor: AppTokens.primarySurfaceLight,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildKpiCard(
                                  context,
                                  title: 'Low Stock Alerts',
                                  value: '${kpis.lowStockCount}',
                                  icon: AppIcons.lowStock,
                                  color: AppTokens.warning,
                                  bgColor: AppTokens.warningSurfaceLight,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildKpiCard(
                                  context,
                                  title: 'Assigned Assets',
                                  value: '${kpis.assignedAssetsCount}',
                                  icon: AppIcons.assignment,
                                  color: AppTokens.info,
                                  bgColor: AppTokens.infoSurfaceLight,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildKpiCard(
                                  context,
                                  title: 'Total SKUs',
                                  value: '${kpis.totalItemsCount}',
                                  icon: AppIcons.asset,
                                  color: AppTokens.primary,
                                  bgColor: AppTokens.primarySurfaceLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildKpiCard(
                              context,
                              title: 'Total Stock Value',
                              value:
                                  '\$${kpis.totalStockValue.toStringAsFixed(2)}',
                              icon: AppIcons.stock,
                              color: AppTokens.primary,
                              bgColor: AppTokens.primarySurfaceLight,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildKpiCard(
                              context,
                              title: 'Low Stock Alerts',
                              value: '${kpis.lowStockCount}',
                              icon: AppIcons.lowStock,
                              color: AppTokens.warning,
                              bgColor: AppTokens.warningSurfaceLight,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildKpiCard(
                              context,
                              title: 'Assigned Assets',
                              value: '${kpis.assignedAssetsCount}',
                              icon: AppIcons.assignment,
                              color: AppTokens.info,
                              bgColor: AppTokens.infoSurfaceLight,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildKpiCard(
                              context,
                              title: 'Catalog SKUs',
                              value: '${kpis.totalItemsCount}',
                              icon: AppIcons.asset,
                              color: AppTokens.primary,
                              bgColor: AppTokens.primarySurfaceLight,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text('Error loading KPIs: $err'),
            ),

            const SizedBox(height: 24),

            // Quick Actions Bar
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text('Quick Ops:',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => context.go('/scan'),
                              icon: const Icon(AppIcons.scanActive, size: 18),
                              label: const Text('Launch Scanner'),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton.icon(
                              onPressed: () => context.go('/handovers/new'),
                              icon: const Icon(AppIcons.assignment, size: 18),
                              label: const Text('New Handover'),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton.icon(
                              onPressed: () => context.go('/inventory/new'),
                              icon: const Icon(AppIcons.add, size: 18),
                              label: const Text('Add Catalog Item'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Charts Section: Stock Movement Trend & Category Distribution
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 900) {
                  return Column(
                    children: [
                      _buildStockMovementChart(context, isDark),
                      const SizedBox(height: 16),
                      _buildCategoryDonutChart(context, isDark),
                    ],
                  );
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3,
                          child: _buildStockMovementChart(context, isDark)),
                      const SizedBox(width: 16),
                      Expanded(
                          flex: 2,
                          child: _buildCategoryDonutChart(context, isDark)),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 24),

            // Recent Asset Handovers Table / List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Recent Asset Assignments',
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.go('/handovers'),
                  icon: const Icon(AppIcons.forward, size: 16),
                  label: const Text('View All Handovers'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            handoversAsync.when(
              data: (handovers) {
                final recent = handovers.take(5).toList();

                if (recent.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                          child: Text('No asset handovers recorded yet.')),
                    ),
                  );
                }

                return Card(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recent.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final h = recent[index];
                      final item = itemsMap[h.itemId];
                      final emp = employeesMap[h.employeeId];
                      final isPerm = h.assignmentType == 'permanent';

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isPerm
                              ? AppTokens.primarySurfaceLight
                              : AppTokens.infoSurfaceLight,
                          child: Icon(
                            isPerm ? AppIcons.assignment : AppIcons.history,
                            color: isPerm ? AppTokens.primary : AppTokens.info,
                            size: 18,
                          ),
                        ),
                        title: Text(item?.name ?? 'Item ${h.itemId}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            'Issued to ${emp?.name ?? h.employeeId} | Project: ${h.projectName ?? "Core"}'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isPerm
                                ? AppTokens.primarySurfaceLight
                                : AppTokens.infoSurfaceLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            h.assignmentType.toUpperCase(),
                            style: TextStyle(
                              color:
                                  isPerm ? AppTokens.primary : AppTokens.info,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error loading handovers: $err'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelSmall),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockMovementChart(BuildContext context, bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Stock Movement Velocity',
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 7, label: Text('7 Days')),
                    ButtonSegment(value: 30, label: Text('30 Days')),
                  ],
                  selected: {_trendDays},
                  onSelectionChanged: (val) {
                    setState(() => _trendDays = val.first);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData:
                      const FlGridData(show: true, drawVerticalLine: false),
                  titlesData: const FlTitlesData(
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 5),
                        FlSpot(1, 12),
                        FlSpot(2, 8),
                        FlSpot(3, 24),
                        FlSpot(4, 18),
                        FlSpot(5, 32),
                        FlSpot(6, 28),
                      ],
                      isCurved: true,
                      color: AppTokens.primary,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTokens.primary.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDonutChart(BuildContext context, bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stock by Category',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            SizedBox(
              height: 204,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                        color: AppTokens.primary,
                        value: 40,
                        title: '40%',
                        radius: 45,
                        titleStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12)),
                    PieChartSectionData(
                        color: AppTokens.info,
                        value: 30,
                        title: '30%',
                        radius: 45,
                        titleStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12)),
                    PieChartSectionData(
                        color: AppTokens.warning,
                        value: 15,
                        title: '15%',
                        radius: 45,
                        titleStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12)),
                    PieChartSectionData(
                        color: Colors.purple,
                        value: 15,
                        title: '15%',
                        radius: 45,
                        titleStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
