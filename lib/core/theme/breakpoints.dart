import 'package:flutter/material.dart';

enum DeviceFormFactor {
  compact,  // Phone (<600dp)
  medium,   // Tablet (600 - 1200dp)
  expanded, // Desktop / Web (>1200dp)
}

extension AppBreakpoints on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  DeviceFormFactor get formFactor {
    final width = screenWidth;
    if (width < 600) {
      return DeviceFormFactor.compact;
    } else if (width < 1200) {
      return DeviceFormFactor.medium;
    } else {
      return DeviceFormFactor.expanded;
    }
  }

  bool get isCompact => formFactor == DeviceFormFactor.compact;
  bool get isMedium => formFactor == DeviceFormFactor.medium;
  bool get isExpanded => formFactor == DeviceFormFactor.expanded;

  bool get showBottomNav => isCompact;
  bool get showNavRail => isMedium;
  bool get showSidebar => isExpanded;
}
