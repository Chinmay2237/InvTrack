import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/tokens.dart';

class BarcodeLabelDialog extends StatelessWidget {
  final String code;
  final String itemName;
  final String sku;

  const BarcodeLabelDialog({
    super.key,
    required this.code,
    required this.itemName,
    required this.sku,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusModal),
      ),
      backgroundColor: isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(AppIcons.scanActive,
                        color: AppTokens.primary, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Printable Asset Label',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(AppIcons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 24),
            // Printable Card Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTokens.radiusCard),
                border: Border.all(color: Colors.grey.shade300, width: 2),
                boxShadow: AppTokens.shadowCardLight,
              ),
              child: Column(
                children: [
                  Text(
                    'INVTRACK ASSET TAG',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 1.2,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  QrImageView(
                    data: code,
                    version: QrVersions.auto,
                    size: 160.0,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    itemName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SKU: $sku | BARCODE: $code',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 11,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Label PDF exported successfully')),
                      );
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(AppIcons.download, size: 18),
                    label: const Text('Export Label'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Label sent to printer')),
                      );
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(AppIcons.exportPdf, size: 18),
                    label: const Text('Print Label'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
