import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop_demo/providers/product_provider.dart';

import '../widgets/product_list_item.dart';

class InventoryListScreen extends StatelessWidget {
  const InventoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: ListView.builder(
        itemCount: productProvider.products.length,
        itemBuilder: (context, index) {
          final product = productProvider.products[index];
          return ProductListItem(
            product: product,
            onTap: () {
              // Navigate to details screen
            },
          );
        },
      ),
    );
  }
}
