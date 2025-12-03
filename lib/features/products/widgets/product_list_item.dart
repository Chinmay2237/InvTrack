import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/core/theme/app_text.dart';
import 'package:myapp/core/theme/app_spacing.dart';
import 'package:myapp/features/products/models/product.dart';
import 'package:myapp/features/products/widgets/stock_status_tag.dart';
import 'package:myapp/features/products/screens/product_detail_screen.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: product.id),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildImage(context),
            ),
            Padding(
              padding: AppSpacing.edgeInsetsAll12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppText.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    product.category,
                    style: AppText.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.space12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${product.price.toStringAsFixed(2)}',
                        style: AppText.titleLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StockStatusTag(quantity: product.quantity),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Hero(
      tag: 'productImage${product.id}',
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              product.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 150,
                  color: AppColors.grey.withOpacity(0.1),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: AppColors.grey.withOpacity(0.1),
                child: const Icon(Icons.broken_image, color: AppColors.grey, size: 40),
              ),
            ),
          ),
          if (product.isLowStock)
            Positioned(
              top: 8,
              left: 8,
              child: Chip(
                label: const Text('Low Stock'),
                backgroundColor: AppColors.lowStock.withOpacity(0.8),
                labelStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                padding: const EdgeInsets.all(4),
              ),
            ),
        ],
      ),
    );
  }
}
