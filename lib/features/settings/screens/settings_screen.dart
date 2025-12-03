import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/core/theme/theme_provider.dart';
import 'package:myapp/features/products/providers/product_provider.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/core/theme/app_text.dart';
import 'package:myapp/core/theme/app_spacing.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: AppSpacing.edgeInsetsAll16,
        children: <Widget>[
          Card(
            child: Padding(
              padding: AppSpacing.edgeInsetsAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: AppText.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.space16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Theme', style: AppText.bodyLarge),
                    subtitle: Text('Select your preferred theme', style: AppText.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    trailing: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode_outlined), label: Text('Light')),
                        ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode_outlined), label: Text('Dark')),
                        ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.settings_system_daydream_outlined), label: Text('System')),
                      ],
                      selected: {themeProvider.themeMode},
                      onSelectionChanged: (Set<ThemeMode> newSelection) {
                        if (newSelection.isNotEmpty) {
                           if (newSelection.first == ThemeMode.system) {
                            themeProvider.setSystemTheme();
                          } else {
                            themeProvider.toggleTheme(newSelection.first == ThemeMode.dark);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space16),
          Card(
            child: ListTile(
              title: Text('Clear All Products', style: AppText.bodyLarge),
              subtitle: Text('This action cannot be undone.', style: AppText.bodyMedium.copyWith(color: AppColors.textSecondary)),
              trailing: const Icon(Icons.delete_forever, color: AppColors.error),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Deletion', style: AppText.titleLarge),
                      content: Text(
                          'Are you sure you want to delete all products? This action cannot be undone.', style: AppText.bodyMedium),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancel', style: AppText.bodyMedium.copyWith(color: AppColors.primary)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Delete', style: AppText.bodyMedium.copyWith(color: AppColors.error)),
                        ),
                      ],
                    );
                  },
                );

                if (confirmed == true) {
                  // ignore: use_build_context_synchronously
                  Provider.of<ProductProvider>(context, listen: false).clearProducts();
                   if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All products have been deleted.'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: AppSpacing.space16),
           Card(
            child: ListTile(
              title: Text('About', style: AppText.bodyLarge),
              subtitle: Text('View application information', style: AppText.bodyMedium.copyWith(color: AppColors.textSecondary)),
              trailing: const Icon(Icons.info_outline),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'InventoryPro',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2024 InventoryPro',
                  applicationIcon: const Icon(Icons.inventory_2_sharp, color: AppColors.primary, size: 48),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
