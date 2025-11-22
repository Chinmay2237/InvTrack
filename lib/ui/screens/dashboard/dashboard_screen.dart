import 'dart:html' as html;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/core/services/auth_service.dart';
import 'package:invtrack/core/services/firestore_service.dart';
import 'package:invtrack/features/products/models/product.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _convertProductsToCsv(List<Product> products) {
    List<List<dynamic>> rows = [];
    rows.add([
      'id',
      'name',
      'serialNumber',
      'category',
      'cost',
      'assignedTo',
      'notes',
      'imageUrl',
      'createdAt',
      'updatedAt'
    ]);
    for (var product in products) {
      rows.add([
        product.id,
        product.name,
        product.serialNumber,
        product.category,
        product.cost,
        product.assignedTo,
        product.notes,
        product.imageUrl,
        product.createdAt?.toIso8601String() ?? '',
        product.updatedAt?.toIso8601String() ?? '',
      ]);
    }
    return const ListToCsvConverter().convert(rows);
  }

  Future<void> _exportProductsToCsv(BuildContext context) async {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    try {
      final products = await firestoreService.getAllProducts();
      if (products.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No products to export.')),
        );
        return;
      }
      final csvContent = _convertProductsToCsv(products);
      final blob = html.Blob([csvContent]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "invtrack_products.csv")
        ..click();
      html.Url.revokeObjectUrl(url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Products exported successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export products: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export to CSV',
            onPressed: () => _exportProductsToCsv(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await authService.signOut();
              GoRouter.of(context).go('/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory Overview',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Gap(16),
            StreamBuilder<List<Product>>(
              stream: firestoreService.getProductsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                final products = snapshot.data!;
                final totalItems = products.length;
                final assignedItems = products.where((p) => p.assignedTo != 'Unassigned').length;
                final availableItems = totalItems - assignedItems;

                return GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.5,
                  children: [
                    _buildInfoCard(
                      context,
                      title: 'Total Items',
                      count: totalItems.toString(),
                      iconUrl: 'https://www.svgrepo.com/show/521677/box.svg',
                      color: Colors.blue.shade100,
                    ),
                    _buildInfoCard(
                      context,
                      title: 'Assigned',
                      count: assignedItems.toString(),
                      iconUrl: 'https://www.svgrepo.com/show/521677/box.svg',
                      color: Colors.orange.shade100,
                    ),
                    _buildInfoCard(
                      context,
                      title: 'Available',
                      count: availableItems.toString(),
                      iconUrl: 'https://www.svgrepo.com/show/521677/box.svg',
                      color: Colors.green.shade100,
                    ),
                  ],
                );
              },
            ),
            const Gap(24),
            Text(
              'Recently Added',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Gap(16),
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: firestoreService.getRecentProducts(limit: 5),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No recent products.'));
                  }

                  final recentProducts = snapshot.data!;
                  return ListView.builder(
                    itemCount: recentProducts.length,
                    itemBuilder: (context, index) {
                      final product = recentProducts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: product.imageUrl ?? 'https://i.imgur.com/8RAH2fL.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Image.network('https://i.imgur.com/8RAH2fL.png', fit: BoxFit.cover), // Generic placeholder

                            ),
                          ),
                          title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Category: ${product.category} | Assigned to: ${product.assignedTo}',
                          ),
                          trailing: Text(
                            '\$${product.cost.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required String count, required String iconUrl, Color color = Colors.grey}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SvgPicture.network(
              iconUrl,
              height: 40,
              width: 40,
              placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
            ),
            const Gap(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
