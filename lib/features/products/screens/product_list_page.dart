import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/features/products/widgets/product_list.dart';

class ProductListPage extends StatelessWidget {
  final String category;
  const ProductListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ProductList(category: category),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/$category/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
