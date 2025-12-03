import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/features/products/providers/product_provider.dart';
import 'package:myapp/features/assign/providers/assign_provider.dart';
import 'package:myapp/features/dashboard/widgets/metric_card.dart';
import 'package:myapp/features/dashboard/widgets/product_carousel.dart';
import 'package:myapp/features/dashboard/widgets/quick_actions_grid.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/core/theme/app_text.dart';
import 'package:myapp/core/theme/app_spacing.dart';
import 'package:myapp/features/dashboard/widgets/category_barchart.dart';
import 'package:myapp/features/dashboard/widgets/project_asset_chart.dart';
import 'package:myapp/features/dashboard/widgets/hero_banner.dart';
import 'package:myapp/shared/widgets/content_container.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductProvider>(context);
    final assignProvider = Provider.of<AssignProvider>(context);
    final lowStockProducts = productsProvider.lowStockItems;
    final justInProducts = productsProvider.justInItems;
    final officeProducts = productsProvider.officeItems;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverToBoxAdapter(child: HeroBanner()),
          SliverToBoxAdapter(
            child: ContentContainer(
              child: Padding(
                padding: AppSpacing.edgeInsetsAll16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inventory Overview',
                      style: AppText.headlineSmall.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.space16),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSpacing.space16,
                      mainAxisSpacing: AppSpacing.space16,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        MetricCard(
                          title: 'Total Products',
                          value: productsProvider.items.length.toString(),
                          icon: Icons.inventory_2_outlined,
                          color: AppColors.primary,
                        ),
                        MetricCard(
                          title: 'Low Stock',
                          value: lowStockProducts.length.toString(),
                          icon: Icons.warning_amber_outlined,
                          color: AppColors.lowStock,
                        ),
                        MetricCard(
                          title: 'Out of Stock',
                          value: productsProvider.outOfStockItems.length.toString(),
                          icon: Icons.error_outline,
                          color: AppColors.outOfStock,
                        ),
                        MetricCard(
                          title: 'Total Value',
                          value: '\$${productsProvider.totalInventoryValue.toStringAsFixed(2)}',
                          icon: Icons.attach_money_outlined,
                          color: AppColors.inStock,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space24),
                    if (justInProducts.isNotEmpty)
                      ProductCarousel(
                        title: 'Just In',
                        products: justInProducts,
                      ),
                    const SizedBox(height: AppSpacing.space24),
                    Text(
                      'Project Asset Allocation',
                      style: AppText.headlineSmall.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.space16),
                    SizedBox(
                      height: 250,
                      child: ProjectAssetChart(projectAssetCounts: assignProvider.projectAssetCounts),
                    ),
                    const SizedBox(height: AppSpacing.space24),
                    if (officeProducts.isNotEmpty)
                      ProductCarousel(
                        title: 'Office Items',
                        products: officeProducts,
                      ),
                    const SizedBox(height: AppSpacing.space24),
                    Text(
                      'Products by Category',
                      style: AppText.headlineSmall.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.space16),
                    SizedBox(
                      height: 300,
                      child: CategoryBarChart(products: productsProvider.items),
                    ),
                    const SizedBox(height: AppSpacing.space24),
                    if (lowStockProducts.isNotEmpty)
                      ProductCarousel(
                        title: 'Low Stock Items',
                        products: lowStockProducts,
                      ),
                    const SizedBox(height: AppSpacing.space24),
                    const QuickActionsGrid(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
