import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/features/products/screens/add_product_screen.dart';
import 'package:myapp/features/products/screens/user_products_screen.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
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
                // Assuming the 2nd tab of BottomNavBar is the product list
                // You might need a more robust navigation solution for this
                // For now, let's just navigate to the screen directly
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UserProductsScreen()));
              },
            ),
            _buildActionCard(
              context,
              icon: Icons.bar_chart_outlined,
              title: 'Reports',
              onTap: () {
                // Placeholder for future reports feature
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
                // Placeholder for future barcode scanner feature
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
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
