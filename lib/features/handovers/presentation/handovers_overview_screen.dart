import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_page_header.dart';
import '../../../core/widgets/app_filter_bar.dart';
import '../../../core/widgets/app_surface.dart';
import '../../../core/widgets/app_activity_row.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_loading_skeleton.dart';
import '../../inventory/domain/entities/item_entity.dart';
import '../../inventory/presentation/providers/inventory_provider.dart';
import 'providers/handover_provider.dart';

class HandoversOverviewScreen extends ConsumerStatefulWidget {
  final String initialFilter;

  const HandoversOverviewScreen({
    super.key,
    this.initialFilter = 'all',
  });

  @override
  ConsumerState<HandoversOverviewScreen> createState() =>
      _HandoversOverviewScreenState();
}

class _HandoversOverviewScreenState
    extends ConsumerState<HandoversOverviewScreen> {
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
  }

  @override
  void didUpdateWidget(covariant HandoversOverviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFilter != widget.initialFilter) {
      setState(() {
        _selectedFilter = widget.initialFilter;
      });
    }
  }

  Future<void> _markReturned(
      BuildContext context, WidgetRef ref, dynamic handover) async {
    final now = DateTime.now();

    await ref.read(returnAssetUseCaseProvider).execute(
          handover.id,
          now,
          notes: 'Device returned safely via Handovers Workspace',
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medical equipment marked as returned')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

    const filterOptions = [
      AppFilterOption(label: 'All Handovers', value: 'all'),
      AppFilterOption(label: 'Permanent', value: 'permanent'),
      AppFilterOption(label: 'Temporary', value: 'temporary'),
      AppFilterOption(label: 'Overdue Queue', value: 'overdue'),
      AppFilterOption(label: 'Returned', value: 'returned'),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header
              AppPageHeader(
                title: 'Asset Handovers',
                subtitle:
                    'Track medical equipment assignments, staff checkouts, and return queues',
                primaryAction: AppPrimaryButton(
                  label: 'New Assignment',
                  icon: AppIcons.add,
                  onPressed: () => context.go('/handovers/new'),
                ),
                secondaryAction: AppSecondaryButton(
                  label: 'Overdue Queue',
                  icon: AppIcons.history,
                  onPressed: () => setState(() => _selectedFilter = 'overdue'),
                ),
              ),

              const SizedBox(height: 20),

              // Filter Segmented Bar
              AppFilterBar<String>(
                options: filterOptions,
                selectedValue: _selectedFilter,
                onSelected: (val) => setState(() => _selectedFilter = val),
              ),

              const SizedBox(height: 20),

              // Main Handovers List Content
              handoversAsync.when(
                data: (handovers) {
                  final filtered = handovers.where((h) {
                    if (_selectedFilter == 'permanent') {
                      return h.assignmentType == 'permanent';
                    }
                    if (_selectedFilter == 'temporary') {
                      return h.assignmentType == 'temporary' &&
                          h.status != 'returned';
                    }
                    if (_selectedFilter == 'returned') {
                      return h.status == 'returned';
                    }
                    if (_selectedFilter == 'overdue') {
                      return h.status == 'overdue';
                    }
                    return true;
                  }).toList();

                  if (filtered.isEmpty) {
                    return AppEmptyState(
                      icon: AppIcons.handovers,
                      title: 'No handovers found',
                      description: _selectedFilter == 'all'
                          ? 'No asset handovers or assignments recorded yet.'
                          : 'No handovers matching the selected filter criteria.',
                      actionLabel: 'Assign First Asset',
                      onAction: () => context.go('/handovers/new'),
                    );
                  }

                  return AppSurface(
                    children: filtered.map((h) {
                      final item = itemsMap[h.itemId];
                      final emp = employeesMap[h.employeeId];
                      final empName = emp?.name ?? 'Employee #${h.employeeId}';
                      final canReturn = h.status != 'returned';

                      return Row(
                        children: [
                          Expanded(
                            child: AppActivityRow(
                              title: item?.name ?? 'Asset #${h.itemId}',
                              subtitle:
                                  'Assigned to $empName (${emp?.department ?? "Clinical"}) · Project ${h.projectName ?? "General"}',
                              employeeName: empName,
                              status: h.status,
                              assignmentType: h.assignmentType,
                              onTap: () {},
                            ),
                          ),
                          if (canReturn)
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: AppSecondaryButton(
                                label: 'Return',
                                icon: AppIcons.success,
                                onPressed: () => _markReturned(context, ref, h),
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  );
                },
                loading: () => AppLoadingSkeleton.listRows(count: 4),
                error: (err, _) => Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text('Error loading handovers: $err',
                      style: const TextStyle(color: AppTokens.critical)),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
