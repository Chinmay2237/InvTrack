import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/core/models/history.dart';
import 'package:invtrack/core/services/firestore_service.dart';
import 'package:invtrack/features/products/models/product.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<Product?> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _fetchProduct();
  }

  Future<Product?> _fetchProduct() {
    final firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    return firestoreService.getProductById(widget.productId);
  }

  Future<void> _deleteProduct(BuildContext context, Product product) async {
    final firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
              onPressed: () => context.pop(false), child: const Text('Cancel')),
          TextButton(
              onPressed: () => context.pop(true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        await firestoreService.deleteProduct(product.id);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Product deleted')));
        if (mounted) context.pop();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
                child: Text('Product not found or failed to load.')),
          );
        }

        final product = snapshot.data!;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, product),
              _buildProductDetails(context, product),
              _buildProductHistory(context, product),
            ],
          ),
        );
      },
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context, Product product) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(product.name,
            style: const TextStyle(shadows: [Shadow(blurRadius: 8)])),
        background: Hero(
          tag: 'product-image-${product.id}',
          child: (product.imageUrl.isNotEmpty)
              ? Image.network(product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100))
              : Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const Center(
                      child: Icon(Icons.inventory_2_outlined, size: 100)),
                ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Edit Product',
          onPressed: () => context.go('/products/${product.id}/edit'),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          tooltip: 'Delete Product',
          onPressed: () => _deleteProduct(context, product),
        ),
      ],
    );
  }

  Widget _buildProductDetails(BuildContext context, Product product) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(context, 'Serial Number', product.serialNumber),
            _buildDetailRow(context, 'Category', product.category),
            _buildDetailRow(
                context, 'Cost', '\$${product.cost.toStringAsFixed(2)}'),
            _buildDetailRow(context, 'Assigned To', product.assignedTo),
            _buildDetailRow(
                context,
                'Created At',
                product.createdAt != null
                    ? DateFormat.yMMMd().add_jm().format(product.createdAt!)
                    : 'N/A'),
            _buildDetailRow(
                context,
                'Last Updated',
                product.updatedAt != null
                    ? DateFormat.yMMMd().add_jm().format(product.updatedAt!)
                    : 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: ListTile(
          title: Text(label,
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          subtitle: Text(value,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildProductHistory(BuildContext context, Product product) {
    final firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

    return StreamBuilder<List<History>>(
      stream: firestoreService.getProductHistory(product.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
              child: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        }

        final history = snapshot.data ?? [];
        if (history.isEmpty) {
          return const SliverToBoxAdapter(
              child: Center(child: Text('No history for this product.')));
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final entry = history[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(entry.action.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(formatter.format(entry.timestamp!)),
              );
            },
            childCount: history.length,
          ),
        );
      },
    );
  }
}
