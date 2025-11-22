import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/features/products/widgets/product_list.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: const ProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/products/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
