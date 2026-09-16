import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/tokens.dart';

final suppliersStreamProvider = StreamProvider<List<Supplier>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.suppliers).watch();
});

class SuppliersOverviewScreen extends ConsumerWidget {
  const SuppliersOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliersAsync = ref.watch(suppliersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(LucideIcons.truck, color: AppTokens.primary, size: 22),
            SizedBox(width: 8),
            Text('Supplier Directory'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left),
          onPressed: () => context.go('/settings'),
        ),
      ),
      body: suppliersAsync.when(
        data: (suppliers) {
          if (suppliers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.truck, size: 48, color: AppTokens.textSecondaryLight),
                  SizedBox(height: 12),
                  Text('No suppliers registered yet.'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              final s = suppliers[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppTokens.primarySurfaceLight,
                    child: Icon(LucideIcons.building, color: AppTokens.primary, size: 20),
                  ),
                  title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Contact: ${s.contactPerson ?? "N/A"} | Phone: ${s.phone ?? "N/A"}'),
                  trailing: Text('${s.leadTimeDays}d lead time', style: Theme.of(context).textTheme.labelSmall),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
