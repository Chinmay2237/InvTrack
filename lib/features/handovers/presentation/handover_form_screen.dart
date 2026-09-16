import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/tokens.dart';
import '../../inventory/presentation/providers/inventory_provider.dart';
import 'providers/handover_provider.dart';

import '../domain/entities/handover_entity.dart';

class HandoverFormScreen extends ConsumerStatefulWidget {
  const HandoverFormScreen({super.key});

  @override
  ConsumerState<HandoverFormScreen> createState() => _HandoverFormScreenState();
}

class _HandoverFormScreenState extends ConsumerState<HandoverFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedItemId;
  String? _selectedEmployeeId;
  String _assignmentType = 'permanent'; // 'permanent' or 'temporary'
  DateTime? _dueDate = DateTime.now().add(const Duration(days: 14));
  bool _isLoading = false;

  @override
  void dispose() {
    _projectController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitHandover() async {
    if (!_formKey.currentState!.validate() || _selectedItemId == null || _selectedEmployeeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an item and an employee')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final handoverId = const Uuid().v4();
    final now = DateTime.now();

    final entity = HandoverEntity(
      id: handoverId,
      itemId: _selectedItemId!,
      employeeId: _selectedEmployeeId!,
      assignmentType: _assignmentType,
      projectName: _projectController.text.trim().isEmpty ? null : _projectController.text.trim(),
      dueDate: _assignmentType == 'temporary' ? _dueDate : null,
      assignedDate: now,
      status: 'active',
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    await ref.read(createHandoverUseCaseProvider).execute(entity);

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asset handover assigned successfully!')),
      );
      context.go('/handovers');
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(itemsStreamProvider);
    final employeesAsync = ref.watch(employeesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Asset Handover'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left),
          onPressed: () => context.go('/handovers'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Assignment Type', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'permanent', label: Text('Permanent Issue'), icon: Icon(LucideIcons.user_check, size: 16)),
                        ButtonSegment(value: 'temporary', label: Text('Temporary Borrow'), icon: Icon(LucideIcons.clock, size: 16)),
                      ],
                      selected: {_assignmentType},
                      onSelectionChanged: (val) {
                        setState(() => _assignmentType = val.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Asset & Employee', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    itemsAsync.when(
                      data: (items) {
                        return DropdownButtonFormField<String>(
                          initialValue: _selectedItemId ?? items.firstOrNull?.id,
                          decoration: const InputDecoration(labelText: 'Select Inventory Item *', prefixIcon: Icon(LucideIcons.box, size: 18)),
                          items: items
                              .map((i) => DropdownMenuItem(
                                    value: i.id,
                                    child: Text('${i.name} (SKU: ${i.sku})'),
                                  ))
                              .toList(),
                          onChanged: (val) => setState(() => _selectedItemId = val),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),
                    employeesAsync.when(
                      data: (employees) {
                        return DropdownButtonFormField<String>(
                          initialValue: _selectedEmployeeId ?? employees.firstOrNull?.id,
                          decoration: const InputDecoration(labelText: 'Assign to Employee *', prefixIcon: Icon(LucideIcons.user, size: 18)),
                          items: employees
                              .map((e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text('${e.name} (${e.department ?? "Staff"})'),
                                  ))
                              .toList(),
                          onChanged: (val) => setState(() => _selectedEmployeeId = val),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _projectController,
                      decoration: const InputDecoration(
                        labelText: 'Project Name (e.g. Core Dev / Site Alpha)',
                        prefixIcon: Icon(LucideIcons.briefcase, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_assignmentType == 'temporary') ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Temporary Due Date', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(LucideIcons.calendar, color: AppTokens.primary),
                        title: Text('Due Return Date: ${_dueDate.toString().split(' ')[0]}'),
                        trailing: OutlinedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 14)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setState(() => _dueDate = picked);
                            }
                          },
                          child: const Text('Change Date'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitHandover,
                icon: const Icon(LucideIcons.check),
                label: const Text('Confirm Asset Handover'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
