import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/features/products/providers/product_provider.dart';
import 'package:myapp/features/products/widgets/stock_status_tag.dart';
import 'package:myapp/core/theme/app_colors.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false).findById(productId);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            floating: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.name, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, shadows: [const Shadow(blurRadius: 10, color: Colors.black45)])),
              background: Hero(
                tag: 'productImage${product.id}',
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 150, color: Colors.white70)),
                ),
              ),
              stretchModes: const [StretchMode.zoomBackground],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(product.name, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(product.category, style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text('Stock:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        StockStatusTag(quantity: product.quantity),
                        const Spacer(),
                        Text('${product.quantity} units', style: theme.textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    Text('Description', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text(product.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6, color: Colors.grey[800])),
                    const SizedBox(height: 100), // Extra space at the bottom
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement edit product functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit functionality coming soon!')),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
