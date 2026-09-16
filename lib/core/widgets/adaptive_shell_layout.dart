import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routing/app_destinations.dart';
import '../theme/app_icons.dart';
import '../theme/breakpoints.dart';
import '../theme/tokens.dart';
import 'track_loop_logo.dart';

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
        backgroundColor:
            isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
        indicatorColor: isDark
            ? AppTokens.primarySurfaceDark
            : AppTokens.primarySurfaceLight,
        elevation: 0,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: AppDestinationConfig.destinations.map((cfg) {
          return NavigationDestination(
            icon: Icon(cfg.icon, size: 20),
            selectedIcon:
                Icon(cfg.activeIcon, size: 20, color: AppTokens.primary),
            label: cfg.label,
          );
        }).toList(),
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
            backgroundColor:
                isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
            indicatorColor: isDark
                ? AppTokens.primarySurfaceDark
                : AppTokens.primarySurfaceLight,
            labelType: NavigationRailLabelType.all,
            minWidth: 76,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: TrackLoopLogo(size: 28),
            ),
            destinations: AppDestinationConfig.destinations.map((cfg) {
              return NavigationRailDestination(
                icon: Icon(cfg.icon, size: 20),
                selectedIcon:
                    Icon(cfg.activeIcon, size: 20, color: AppTokens.primary),
                label: Text(cfg.label, style: const TextStyle(fontSize: 11)),
              );
            }).toList(),
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: isDark ? AppTokens.borderDark : AppTokens.borderLight,
          ),
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
            width: 240,
            color: isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
            child: Column(
              children: [
                // App Brand Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Row(
                    children: [
                      const TrackLoopLogo(size: 30),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'InvTrack',
                            style: GoogleFonts.lora(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: isDark
                                  ? AppTokens.textPrimaryDark
                                  : AppTokens.textPrimaryLight,
                            ),
                          ),
                          Text(
                            'Asset & Stock Control',
                            style: GoogleFonts.plusJakartaSans(
                              color: isDark
                                  ? AppTokens.textSecondaryDark
                                  : AppTokens.textSecondaryLight,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppTokens.borderDark : AppTokens.borderLight,
                ),
                const SizedBox(height: 16),
                // Nav Items List (Mapped from AppDestinationConfig)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: AppDestinationConfig.destinations.length,
                    itemBuilder: (context, index) {
                      final cfg = AppDestinationConfig.destinations[index];
                      final isSelected = navigationShell.currentIndex == index;
                      return _SidebarNavItem(
                        icon: isSelected ? cfg.activeIcon : cfg.icon,
                        label: cfg.label,
                        tooltip: cfg.accessibilityLabel,
                        isSelected: isSelected,
                        onTap: () => _onDestinationSelected(index),
                      );
                    },
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppTokens.borderDark : AppTokens.borderLight,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTokens.primarySurfaceDark
                              : AppTokens.primarySurfaceLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(AppIcons.user,
                            size: 16, color: AppTokens.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Operations Team',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppTokens.success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Offline Ready',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        fontSize: 10,
                                      ),
                                ),
                              ],
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
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: isDark ? AppTokens.borderDark : AppTokens.borderLight,
          ),
          // Constrained Central Content Canvas (Max-width 1360px for elegant editorial proportion)
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1360),
                child: navigationShell,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isSelected
        ? (isDark
            ? AppTokens.primarySurfaceDark
            : AppTokens.primarySurfaceLight)
        : Colors.transparent;

    final textColor = isSelected
        ? AppTokens.primary
        : (isDark ? AppTokens.textPrimaryDark : AppTokens.textPrimaryLight);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppTokens.radiusButton),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppTokens.radiusButton),
            hoverColor: isDark
                ? AppTokens.surfaceAltDark.withValues(alpha: 0.5)
                : AppTokens.surfaceAltLight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: textColor),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      color: textColor,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
