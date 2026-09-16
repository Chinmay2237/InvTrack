import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_icons.dart';
import '../theme/tokens.dart';
import 'app_status_badge.dart';
import 'pressable_scale.dart';

/// Specialty inventory item row component for iOS lists and tables.
class AppAssetRow extends StatelessWidget {
  final String name;
  final String sku;
  final String? barcode;
  final double salePrice;
  final String? status;
  final String? imageUrl;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const AppAssetRow({
    super.key,
    required this.name,
    required this.sku,
    this.barcode,
    required this.salePrice,
    this.status,
    this.imageUrl,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget avatar;
    if (imageUrl != null && imageUrl!.startsWith('assets/')) {
      avatar = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imageUrl!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallbackIcon(isDark),
        ),
      );
    } else {
      avatar = _buildFallbackIcon(isDark);
    }

    final content = Padding(
      padding: padding,
      child: Row(
        children: [
          avatar,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppTokens.textPrimaryDark
                              : AppTokens.textPrimaryLight,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${salePrice.toStringAsFixed(2)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTokens.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTokens.surfaceAltDark
                            : AppTokens.surfaceAltLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        sku,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppTokens.textSecondaryDark
                              : AppTokens.textSecondaryLight,
                        ),
                      ),
                    ),
                    if (barcode != null && barcode!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        'BC: $barcode',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: isDark
                              ? AppTokens.textSecondaryDark
                              : AppTokens.textSecondaryLight,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (status != null) ...[
                      AppStatusBadge(status: status!, isCompact: true),
                      const SizedBox(width: 6),
                    ],
                    Icon(
                      AppIcons.forward,
                      size: 16,
                      color: isDark
                          ? AppTokens.textDisabledDark
                          : AppTokens.textDisabledLight,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;

    return PressableScale(
      onTap: onTap,
      child: content,
    );
  }

  Widget _buildFallbackIcon(bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark
            ? AppTokens.primarySurfaceDark
            : AppTokens.primarySurfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(AppIcons.inventory, size: 20, color: AppTokens.primary),
    );
  }
}
