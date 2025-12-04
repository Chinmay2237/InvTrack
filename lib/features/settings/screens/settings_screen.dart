import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              _buildProfileSection(context, name: 'John Doe', email: 'john.doe@example.com'),
              const SizedBox(height: 24),
              const Divider(),

              // Theme Settings
              _buildSectionHeader(context, title: 'Appearance'),
              _buildSettingsTile(context, title: 'Dark Mode', isEnabled: themeProvider.themeMode == ThemeMode.dark, onChanged: (value) {
                themeProvider.toggleTheme();
              }),
              const SizedBox(height: 16),
              const Divider(),

              // Notification Settings
              _buildSectionHeader(context, title: 'Notifications'),
              _buildSettingsTile(context, title: 'Push Notifications', isEnabled: true, onChanged: (value) {}),
              _buildSettingsTile(context, title: 'Email Notifications', isEnabled: false, onChanged: (value) {}),
              const SizedBox(height: 16),
              const Divider(),

              // Legal Information
              _buildSectionHeader(context, title: 'Legal'),
              _buildInfoTile(context, title: 'Terms of Service', onTap: () {}),
              _buildInfoTile(context, title: 'Privacy Policy', onTap: () {}),
              const SizedBox(height: 16),
              const Divider(),

              // Logout
              const SizedBox(height: 24),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, {required String name, required String email}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {required String title, required bool isEnabled, required ValueChanged<bool> onChanged}) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      trailing: Switch(
        value: isEnabled,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildInfoTile(BuildContext context, {required String title, required VoidCallback onTap}) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle logout
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
