import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/core/theme/theme_provider.dart';
import 'package:myapp/features/products/providers/product_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Theme'),
                    subtitle: const Text('Select your preferred theme'),
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
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Clear All Products'),
              subtitle: const Text('This action cannot be undone.'),
              trailing: const Icon(Icons.delete_forever, color: Colors.red),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                          'Are you sure you want to delete all products? This action cannot be undone.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );

                if (confirmed == true) {
                  // ignore: use_build_context_synchronously
                  Provider.of<ProductProvider>(context, listen: false).clearProducts();
                }
              },
            ),
          ),
          const SizedBox(height: 16),
           Card(
            child: ListTile(
              title: const Text('About'),
              subtitle: const Text('View application information'),
              trailing: const Icon(Icons.info_outline),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Inventory Management',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2024 Your Company',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
