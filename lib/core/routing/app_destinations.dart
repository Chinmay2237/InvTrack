import 'package:flutter/material.dart';
import '../theme/app_icons.dart';

enum AppDestination {
  dashboard,
  inventory,
  scan,
  handovers,
  settings,
}

class AppDestinationConfig {
  final AppDestination destination;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  final String accessibilityLabel;

  const AppDestinationConfig({
    required this.destination,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    required this.accessibilityLabel,
  });

  static const List<AppDestinationConfig> destinations = [
    AppDestinationConfig(
      destination: AppDestination.dashboard,
      label: 'Dashboard',
      icon: AppIcons.dashboard,
      activeIcon: AppIcons.dashboardActive,
      route: '/',
      accessibilityLabel: 'Navigate to Dashboard overview',
    ),
    AppDestinationConfig(
      destination: AppDestination.inventory,
      label: 'Inventory',
      icon: AppIcons.inventory,
      activeIcon: AppIcons.inventoryActive,
      route: '/inventory',
      accessibilityLabel: 'Navigate to Medical device inventory catalog',
    ),
    AppDestinationConfig(
      destination: AppDestination.scan,
      label: 'Scan Station',
      icon: AppIcons.scan,
      activeIcon: AppIcons.scanActive,
      route: '/scan',
      accessibilityLabel: 'Navigate to Barcode scanning station',
    ),
    AppDestinationConfig(
      destination: AppDestination.handovers,
      label: 'Handovers',
      icon: AppIcons.handovers,
      activeIcon: AppIcons.handoversActive,
      route: '/handovers',
      accessibilityLabel: 'Navigate to Asset handovers and assignments',
    ),
    AppDestinationConfig(
      destination: AppDestination.settings,
      label: 'Settings',
      icon: AppIcons.settings,
      activeIcon: AppIcons.settingsActive,
      route: '/settings',
      accessibilityLabel: 'Navigate to System settings and configurations',
    ),
  ];
}
