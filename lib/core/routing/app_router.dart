import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/adaptive_shell_layout.dart';
import '../widgets/connectivity_banner.dart';

import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/inventory/presentation/inventory_overview_screen.dart';
import '../../features/inventory/presentation/item_detail_screen.dart';
import '../../features/inventory/presentation/item_form_screen.dart';
import '../../features/scanning/presentation/scanning_screen.dart';
import '../../features/handovers/presentation/handovers_overview_screen.dart';
import '../../features/handover_queue/presentation/handover_queue_screen.dart';
import '../../features/handovers/presentation/handover_form_screen.dart';
import '../../features/reports_analytics/presentation/reports_analytics_screen.dart';
import '../../features/stock_movements/presentation/stock_movements_screen.dart';
import '../../features/suppliers/presentation/suppliers_overview_screen.dart';
import '../../features/purchase_orders/presentation/purchase_orders_overview_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

import '../../features/splash/presentation/splash_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

Page<dynamic> _buildSmoothPage({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.04, 0.0);
      const end = Offset.zero;
      final slideTween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.fastOutSlowIn));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut));

      return SlideTransition(
        position: animation.drive(slideTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ConnectivityBannerWrapper(
          child: AdaptiveShellLayout(navigationShell: navigationShell),
        );
      },
      branches: [
        // Branch 0: Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => _buildSmoothPage(
                context: context,
                state: state,
                child: const DashboardScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'reports',
                  pageBuilder: (context, state) => _buildSmoothPage(
                    context: context,
                    state: state,
                    child: const ReportsAnalyticsScreen(),
                  ),
                ),
                GoRoute(
                  path: 'stock-movements',
                  pageBuilder: (context, state) => _buildSmoothPage(
                    context: context,
                    state: state,
                    child: const StockMovementsScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Branch 1: Inventory
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              pageBuilder: (context, state) => _buildSmoothPage(
                context: context,
                state: state,
                child: const InventoryOverviewScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'new',
                  pageBuilder: (context, state) => _buildSmoothPage(
                    context: context,
                    state: state,
                    child: const ItemFormScreen(),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  pageBuilder: (context, state) => _buildSmoothPage(
                    context: context,
                    state: state,
                    child: ItemDetailScreen(
                      itemId: state.pathParameters['id']!,
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      pageBuilder: (context, state) => _buildSmoothPage(
                        context: context,
                        state: state,
                        child: ItemFormScreen(
                          itemId: state.pathParameters['id']!,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Branch 2: Scanning Station
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/scan',
              pageBuilder: (context, state) => _buildSmoothPage(
                context: context,
                state: state,
                child: const ScanningScreen(),
              ),
            ),
          ],
        ),

        // Branch 3: Handovers & Asset Assignment
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/handovers',
              pageBuilder: (context, state) => _buildSmoothPage(
                context: context,
                state: state,
                child: const HandoversOverviewScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'new',
                  pageBuilder: (context, state) => _buildSmoothPage(
                    context: context,
                    state: state,
                    child: const HandoverFormScreen(),
                  ),
                ),
                GoRoute(
                  path: 'queue',
                  pageBuilder: (context, state) => _buildSmoothPage(
                    context: context,
                    state: state,
                    child: const HandoverQueueScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Branch 4: Settings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => _buildSmoothPage(
                context: context,
                state: state,
                child: const SettingsScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'suppliers',
                  pageBuilder: (context, state) => _buildSmoothPage(
                    context: context,
                    state: state,
                    child: const SuppliersOverviewScreen(),
                  ),
                ),
                GoRoute(
                  path: 'purchase-orders',
                  pageBuilder: (context, state) => _buildSmoothPage(
                    context: context,
                    state: state,
                    child: const PurchaseOrdersOverviewScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
