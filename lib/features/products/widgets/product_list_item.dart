import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../models/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final bool isListView;

  const ProductListItem({super.key, required this.product, this.isListView = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Widget image = Hero(
      tag: 'product-image-${product.id}',
      child: ClipRRect(
        borderRadius: isListView 
            ? BorderRadius.circular(12.0)
            : const BorderRadius.vertical(top: Radius.circular(16.0)),
        child: CachedNetworkImage(
          imageUrl: product.imageUrl ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(color: Colors.white),
          ),
          errorWidget: (context, url, error) => Container(
            color: theme.colorScheme.surface,
            child: const Center(
              child: Icon(Icons.broken_image_rounded, size: 40, color: AppColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          product.name,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          maxLines: isListView ? 2 : 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (isListView) const SizedBox(height: 4.0),
        if (isListView)
          Text(
            product.description,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withAlpha(178)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            Text(
              'Qty: ${product.quantity}',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withAlpha(178)),
            ),
          ],
        ),
      ],
    );

    if (isListView) {
      return _buildListViewItem(context, image, content);
    } else {
      return _buildGridViewItem(context, image, content);
    }
  }

  Widget _buildGridViewItem(BuildContext context, Widget image, Widget content) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        onTap: () => context.go('/products/${product.id}'),
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: image),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListViewItem(BuildContext context, Widget image, Widget content) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () => context.go('/products/${product.id}'),
        borderRadius: BorderRadius.circular(12.0),
        child: Row(
          children: [
            SizedBox(width: 120, height: 120, child: image),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
