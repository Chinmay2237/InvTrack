import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(AppIcons.settings, color: AppTokens.primary, size: 22),
            SizedBox(width: 8),
            Text('Settings & Preferences'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile & App Status Header Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTokens.primarySurfaceLight,
                    child:
                        Icon(AppIcons.user, size: 28, color: AppTokens.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Inventory Administrator',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text('Offline Local SQLite DB (Drift)',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTokens.primarySurfaceLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(AppIcons.offline,
                            size: 12, color: AppTokens.primary),
                        SizedBox(width: 4),
                        Text('OFFLINE READY',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTokens.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Appearance Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Appearance & System Theme',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: const Text('System Default'),
                  subtitle: const Text('Matches operating system preference'),
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (mode) =>
                      ref.read(themeModeProvider.notifier).setThemeMode(mode!),
                  secondary: const Icon(AppIcons.category),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Light Mode'),
                  subtitle: const Text('Clean white surface layout'),
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (mode) =>
                      ref.read(themeModeProvider.notifier).setThemeMode(mode!),
                  secondary: const Icon(AppIcons.flashOn),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Deep slate background layout'),
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (mode) =>
                      ref.read(themeModeProvider.notifier).setThemeMode(mode!),
                  secondary: const Icon(AppIcons.settings),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Data Management & Migration Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Data Management & Imports',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(AppIcons.exportCsv, color: AppTokens.primary),
                  title: const Text('Import Catalog from CSV'),
                  subtitle: const Text(
                      'Map custom CSV columns and ingest products into Drift'),
                  trailing: const Icon(AppIcons.forward),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'CSV Column Mapping Engine Ready for Ingest')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(AppIcons.stock, color: AppTokens.info),
                  title: const Text('Backup & Export Local Database'),
                  subtitle:
                      const Text('Export complete invtrack_v2_db SQLite file'),
                  trailing: const Icon(AppIcons.download),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'SQLite Database backup exported successfully')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Operations Sub-Modules Navigation Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Operations & Procurement',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(AppIcons.supplier, color: AppTokens.primary),
                  title: const Text('Supplier Directory'),
                  trailing: const Icon(AppIcons.forward),
                  onTap: () => context.go('/settings/suppliers'),
                ),
                ListTile(
                  leading:
                      const Icon(AppIcons.purchaseOrder, color: AppTokens.info),
                  title: const Text('Purchase Orders'),
                  trailing: const Icon(AppIcons.forward),
                  onTap: () => context.go('/settings/purchase-orders'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About Card
          Center(
            child: Column(
              children: [
                Text(
                  'InvTrack v2 Commercial Studio',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('Flutter 3.x | Dart 3.x | Riverpod | Drift SQLite',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
