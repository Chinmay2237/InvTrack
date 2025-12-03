import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/features/products/providers/product_provider.dart';
import 'package:myapp/features/dashboard/widgets/metric_card.dart';
import 'package:myapp/features/dashboard/widgets/product_carousel.dart';
import 'package:myapp/features/dashboard/widgets/quick_actions_grid.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/features/dashboard/widgets/category_barchart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductProvider>(context);
    final lowStockProducts = productsProvider.lowStockItems;
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: const Text('Dashboard'),
            floating: true,
            pinned: true,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inventory Overview',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
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
                        value:
                            productsProvider.outOfStockItems.length.toString(),
                        icon: Icons.error_outline,
                        color: AppColors.outOfStock,
                      ),
                      MetricCard(
                        title: 'Total Value',
                        value:
                            '\$${productsProvider.totalInventoryValue.toStringAsFixed(2)}',
                        icon: Icons.attach_money_outlined,
                        color: AppColors.inStock,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Products by Category',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: CategoryBarChart(products: productsProvider.items),
                  ),
                  const SizedBox(height: 24),
                  if (lowStockProducts.isNotEmpty)
                    ProductCarousel(
                      title: 'Low Stock Items',
                      products: lowStockProducts,
                    ),
                  const SizedBox(height: 24),
                  const QuickActionsGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
