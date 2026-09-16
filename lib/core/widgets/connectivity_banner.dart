import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../theme/tokens.dart';

final isOfflineProvider = StateProvider<bool>((ref) => false);

class ConnectivityBannerWrapper extends ConsumerWidget {
  final Widget child;

  const ConnectivityBannerWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isOffline ? 36.0 : 0.0,
          color: AppTokens.warningSurfaceLight,
          child: OverflowBox(
            maxHeight: 36.0,
            minHeight: 0.0,
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTokens.warning, width: 1)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.wifi_off, size: 14, color: AppTokens.warning),
                  SizedBox(width: 8),
                  Text(
                    'Offline Mode Active — SQLite Local Database Synced',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.warning,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
