import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/core/services/auth_service.dart';
import 'package:invtrack/core/services/firestore_service.dart'; // Import FirestoreService
import 'package:provider/provider.dart';
import 'package:csv/csv.dart'; // Import csv package
import 'package:invtrack/features/products/models/product.dart'; // Import Product model

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Function to convert product list to CSV string
  String _convertProductsToCsv(List<Product> products) {
    List<List<dynamic>> rows = [];

    // Add headers
    rows.add([
      'id',
      'name',
      'serialNumber',
      'category',
      'cost',
      'price',
      'assignedTo',
      'notes',
      'imageUrl',
      'createdAt',
      'updatedAt'
    ]);

    // Add product data
    for (var product in products) {
      rows.add([
        product.id,
        product.name,
        product.serialNumber,
        product.category,
        product.cost,
        product.price,
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
    final firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    try {
      final products = await firestoreService.getAllProducts();
      if (products.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No products to export.')),
          );
        }
        return;
      }
      final csvContent = _convertProductsToCsv(products);

      // This is a placeholder for web download functionality.
      // You would use a package like `universal_html` to create a download link.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV export is not implemented yet.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export products: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    // Placeholder data for the cards
    final List<Map<String, String>> dashboardCards = [
      {'title': 'Total Items', 'count': '150'},
      {'title': 'Assigned', 'count': '80'},
      {'title': 'Available', 'count': '70'},
    ];

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
              if (context.mounted) {
                GoRouter.of(context).go('/login');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.5, // Adjust card aspect ratio
          ),
          itemCount: dashboardCards.length,
          itemBuilder: (context, index) {
            final cardData = dashboardCards[index];
            return Card(
              elevation: 4.0, // Soft shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: InkWell(
                onTap: () {
                  // Optional: Implement navigation to relevant lists later
                  // For now, no action on tap
                },
                borderRadius: BorderRadius.circular(12.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cardData['title']!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        cardData['count']!,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
