
import 'package:flutter/material.dart';
import 'package:invtrack/core/services/firestore_service.dart';
import 'package:invtrack/features/products/models/product.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ProductList extends StatelessWidget {
  final String category;
  const ProductList({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    return StreamBuilder<List<Product>>(
      stream: firestoreService.getProducts(category),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data ?? [];

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('Quantity: ${product.quantity}'),
              trailing: Text('\$${product.price.toStringAsFixed(2)}'),
              onTap: () => context.go('/$category/details/${product.id}'),
            );
          },
        );
      },
    );
  }
}
