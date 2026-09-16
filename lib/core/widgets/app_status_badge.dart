import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

/// Centralized status badge mapping for inventory, handover, and system states.
/// Formatted with soft native iOS status colors.
class AppStatusBadge extends StatelessWidget {
  final String status;
  final bool isCompact;

  const AppStatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final normalized = status.toLowerCase().replaceAll(' ', '_');

    Color bgColor;
    Color textColor;
    String displayLabel = status.toUpperCase();

    switch (normalized) {
      case 'available':
      case 'in_stock':
      case 'healthy':
        bgColor = isDark
            ? AppTokens.successSurfaceDark
            : AppTokens.successSurfaceLight;
        textColor = AppTokens.success;
        displayLabel = 'AVAILABLE';
        break;

      case 'assigned':
      case 'active':
      case 'permanent':
        bgColor = isDark
            ? AppTokens.primarySurfaceDark
            : AppTokens.primarySurfaceLight;
        textColor = AppTokens.primary;
        displayLabel = normalized == 'permanent' ? 'PERMANENT' : 'ASSIGNED';
        break;

      case 'temporary':
        bgColor =
            isDark ? AppTokens.infoSurfaceDark : AppTokens.infoSurfaceLight;
        textColor = AppTokens.info;
        displayLabel = 'TEMPORARY';
        break;

      case 'low_stock':
      case 'pending':
        bgColor = isDark
            ? AppTokens.warningSurfaceDark
            : AppTokens.warningSurfaceLight;
        textColor = AppTokens.warning;
        displayLabel = normalized == 'pending' ? 'PENDING' : 'LOW STOCK';
        break;

      case 'overdue':
      case 'out_of_stock':
      case 'critical':
        bgColor = isDark
            ? AppTokens.criticalSurfaceDark
            : AppTokens.criticalSurfaceLight;
        textColor = AppTokens.critical;
        displayLabel = normalized == 'overdue' ? 'OVERDUE' : 'OUT OF STOCK';
        break;

      case 'returned':
      case 'archived':
      default:
        bgColor = isDark ? AppTokens.surfaceAltDark : AppTokens.surfaceAltLight;
        textColor =
            isDark ? AppTokens.textSecondaryDark : AppTokens.textSecondaryLight;
        displayLabel = status.toUpperCase();
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 9,
        vertical: isCompact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTokens.radiusChip),
      ),
      child: Text(
        displayLabel,
        style: GoogleFonts.plusJakartaSans(
          fontSize: isCompact ? 9.5 : 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: textColor,
        ),
      ),
    );
  }
}
