import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/tokens.dart';
import 'providers/purchase_order_provider.dart';

class PurchaseOrdersOverviewScreen extends ConsumerWidget {
  const PurchaseOrdersOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posAsync = ref.watch(purchaseOrdersListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(AppIcons.purchaseOrder, color: AppTokens.primary, size: 22),
            SizedBox(width: 8),
            Text('Purchase Orders'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => context.go('/settings'),
        ),
      ),
      body: posAsync.when(
        data: (pos) {
          if (pos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(AppIcons.purchaseOrder,
                      size: 48, color: AppTokens.textSecondaryLight),
                  SizedBox(height: 12),
                  Text('No purchase orders registered.'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pos.length,
            itemBuilder: (context, index) {
              final po = pos[index];
              final isReceived = po.status == 'received';

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isReceived
                        ? AppTokens.primarySurfaceLight
                        : AppTokens.warningSurfaceLight,
                    child: Icon(
                      isReceived ? AppIcons.success : AppIcons.history,
                      color: isReceived ? AppTokens.primary : AppTokens.warning,
                      size: 20,
                    ),
                  ),
                  title: Text('PO #${po.poNumber}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Supplier: ${po.supplierId} | Items: ${po.items.length} | Created: ${po.createdAt.toString().split(' ')[0]}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isReceived
                              ? AppTokens.primarySurfaceLight
                              : AppTokens.warningSurfaceLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          po.status.toUpperCase(),
                          style: TextStyle(
                            color: isReceived
                                ? AppTokens.primary
                                : AppTokens.warning,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      if (!isReceived) ...[
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final db = ref.read(databaseProvider);
                            final mainWh =
                                (await db.select(db.warehouses).get())
                                    .firstOrNull;
                            if (mainWh != null) {
                              await ref
                                  .read(receivePurchaseOrderUseCaseProvider)
                                  .execute(po.id, mainWh.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Received PO #${po.poNumber} & incremented stock levels')),
                                );
                              }
                            }
                          },
                          icon: const Icon(AppIcons.back, size: 14),
                          label: const Text('Receive Stock'),
                        ),
                      ],
                    ],
                  ),
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
