import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/core/theme/app_text.dart';
import 'package:myapp/core/theme/app_spacing.dart';
import 'package:myapp/features/products/screens/add_product_screen.dart';
import 'package:myapp/features/products/screens/user_products_screen.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppText.titleLarge,
        ),
        const SizedBox(height: AppSpacing.space16),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.space16,
          mainAxisSpacing: AppSpacing.space16,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildActionCard(
              context,
              icon: Icons.add_circle_outline,
              title: 'Add Product',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddProductScreen()));
              },
            ),
            _buildActionCard(
              context,
              icon: Icons.inventory_2_outlined,
              title: 'View All Products',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UserProductsScreen()));
              },
            ),
            _buildActionCard(
              context,
              icon: Icons.bar_chart_outlined,
              title: 'Reports',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reports feature coming soon!')),
                );
              },
            ),
            _buildActionCard(
              context,
              icon: Icons.camera_alt_outlined,
              title: 'Scan Barcode',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Barcode scanner coming soon!')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(height: AppSpacing.space16),
            Text(title, textAlign: TextAlign.center, style: AppText.titleMedium),
          ],
        ),
      ),
    );
  }
}
