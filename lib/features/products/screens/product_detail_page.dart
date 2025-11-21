import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/core/services/firestore_service.dart';
import 'package:invtrack/features/products/models/product.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:invtrack/core/models/history.dart'; // Import for History model

class ProductDetailPage extends StatefulWidget {
  final String category;
  final String productId;
  const ProductDetailPage(
      {super.key, required this.category, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Future<void> _deleteProduct() async {
    final firestoreService =
        Provider.of<FirestoreService>(context, listen: false);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await firestoreService.deleteProduct(widget.productId);
      if (mounted) {
        context.pop(); // Go back to the product list after deletion
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService =
        Provider.of<FirestoreService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: FutureBuilder<Product>(
        future: firestoreService.getProductById(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Product not found.'));
          }

          final product = snapshot.data!;
          final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                  Center(
                    child: Hero(
                      tag: 'product-image-${product.id}', // Hero tag for the image
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          product.imageUrl!,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 100),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                Text('Name: ${product.name}',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Serial Number: ${product.serialNumber}',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Category: ${product.category}',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Cost: \$${product.cost.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text('Assigned To: ${product.assignedTo}'),
                const SizedBox(height: 8),
                Text('Notes: ${product.notes.isEmpty ? 'N/A' : product.notes}'),
                const SizedBox(height: 8),
                Text(
                    'Created At: ${product.createdAt != null ? formatter.format(product.createdAt!) : 'N/A'}'),
                const SizedBox(height: 8),
                Text(
                    'Updated At: ${product.updatedAt != null ? formatter.format(product.updatedAt!) : 'N/A'}'),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton.extended(
                      heroTag: 'editBtn-${product.id}',
                      onPressed: () => context
                          .go('/${widget.category}/edit/${widget.productId}'),
                      label: const Text('Edit'),
                      icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(width: 16),
                    FloatingActionButton.extended(
                      heroTag: 'deleteBtn-${product.id}',
                      onPressed: _deleteProduct,
                      label: const Text('Delete'),
                      icon: const Icon(Icons.delete),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),

                Text('Product History',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                StreamBuilder<List<History>>(
                  stream: firestoreService.getProductHistory(widget.productId),
                  builder: (context, historySnapshot) {
                    if (historySnapshot.hasError) {
                      return Text('Error loading history: ${historySnapshot.error}');
                    }
                    if (historySnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final historyEntries = historySnapshot.data ?? [];

                    if (historyEntries.isEmpty) {
                      return const Text('No history available for this product.');
                    }

                    return ListView.builder(
                      shrinkWrap: true, // Important for nested ListViews
                      physics: const NeverScrollableScrollPhysics(), // Important for nested ListViews
                      itemCount: historyEntries.length,
                      itemBuilder: (context, index) {
                        final entry = historyEntries[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // Ensure entry.timestamp is not null before formatting
                                  '${entry.action.toUpperCase()} - ${entry.timestamp != null ? formatter.format(entry.timestamp!) : 'N/A'}',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                // if (entry.details.isNotEmpty)
                                //   Padding(
                                //     padding: const EdgeInsets.only(top: 4.0),
                                //     child: Text(entry.details),
                                //   ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}