import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../theme/breakpoints.dart';
import '../theme/tokens.dart';

class AdaptiveShellLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AdaptiveShellLayout({
    super.key,
    required this.navigationShell,
  });

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formFactor = context.formFactor;

    switch (formFactor) {
      case DeviceFormFactor.compact:
        return _buildCompactLayout(context);
      case DeviceFormFactor.medium:
        return _buildMediumLayout(context);
      case DeviceFormFactor.expanded:
        return _buildExpandedLayout(context);
    }
  }

  // --- Compact (Phone) Layout ---
  Widget _buildCompactLayout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        backgroundColor: isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
        indicatorColor: isDark ? AppTokens.primarySurfaceDark : AppTokens.primarySurfaceLight,
        elevation: 4,
        destinations: const [
          NavigationDestination(
            icon: Icon(LucideIcons.layout_dashboard),
            selectedIcon: Icon(LucideIcons.layout_dashboard, color: AppTokens.primary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.box),
            selectedIcon: Icon(LucideIcons.box, color: AppTokens.primary),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.qr_code),
            selectedIcon: Icon(LucideIcons.qr_code, color: AppTokens.primary),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.user_check),
            selectedIcon: Icon(LucideIcons.user_check, color: AppTokens.primary),
            label: 'Handovers',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.settings),
            selectedIcon: Icon(LucideIcons.settings, color: AppTokens.primary),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // --- Medium (Tablet) Layout ---
  Widget _buildMediumLayout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            backgroundColor: isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
            indicatorColor: isDark ? AppTokens.primarySurfaceDark : AppTokens.primarySurfaceLight,
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTokens.primary,
                  borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                ),
                child: const Icon(LucideIcons.boxes, color: Colors.white, size: 24),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(LucideIcons.layout_dashboard),
                selectedIcon: Icon(LucideIcons.layout_dashboard, color: AppTokens.primary),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(LucideIcons.box),
                selectedIcon: Icon(LucideIcons.box, color: AppTokens.primary),
                label: Text('Inventory'),
              ),
              NavigationRailDestination(
                icon: Icon(LucideIcons.qr_code),
                selectedIcon: Icon(LucideIcons.qr_code, color: AppTokens.primary),
                label: Text('Scan'),
              ),
              NavigationRailDestination(
                icon: Icon(LucideIcons.user_check),
                selectedIcon: Icon(LucideIcons.user_check, color: AppTokens.primary),
                label: Text('Handovers'),
              ),
              NavigationRailDestination(
                icon: Icon(LucideIcons.settings),
                selectedIcon: Icon(LucideIcons.settings, color: AppTokens.primary),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: AppTokens.borderLight),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }

  // --- Expanded (Desktop/Web) Layout ---
  Widget _buildExpandedLayout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
            child: Column(
              children: [
                // App Brand Header
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTokens.primary,
                          borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                        ),
                        child: const Icon(LucideIcons.boxes, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'InvTrack',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                          ),
                          Text(
                            'v2 Enterprise Studio',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppTokens.primary,
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppTokens.borderLight),
                const SizedBox(height: 16),
                // Nav Items List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      _SidebarNavItem(
                        icon: LucideIcons.layout_dashboard,
                        label: 'Dashboard',
                        isSelected: navigationShell.currentIndex == 0,
                        onTap: () => _onDestinationSelected(0),
                      ),
                      _SidebarNavItem(
                        icon: LucideIcons.box,
                        label: 'Inventory',
                        isSelected: navigationShell.currentIndex == 1,
                        onTap: () => _onDestinationSelected(1),
                      ),
                      _SidebarNavItem(
                        icon: LucideIcons.qr_code,
                        label: 'Scan Station',
                        isSelected: navigationShell.currentIndex == 2,
                        onTap: () => _onDestinationSelected(2),
                      ),
                      _SidebarNavItem(
                        icon: LucideIcons.user_check,
                        label: 'Asset Handovers',
                        isSelected: navigationShell.currentIndex == 3,
                        onTap: () => _onDestinationSelected(3),
                      ),
                      _SidebarNavItem(
                        icon: LucideIcons.settings,
                        label: 'Settings',
                        isSelected: navigationShell.currentIndex == 4,
                        onTap: () => _onDestinationSelected(4),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppTokens.borderLight),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: AppTokens.primarySurfaceLight,
                        child: Icon(LucideIcons.user, size: 16, color: AppTokens.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Inventory Ops',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Offline Local Database',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1, color: AppTokens.borderLight),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isSelected
        ? (isDark ? AppTokens.primarySurfaceDark : AppTokens.primarySurfaceLight)
        : Colors.transparent;

    final textColor = isSelected
        ? AppTokens.primary
        : (isDark ? AppTokens.textPrimaryDark : AppTokens.textPrimaryLight);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTokens.radiusButton),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTokens.radiusButton),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 20, color: textColor),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
