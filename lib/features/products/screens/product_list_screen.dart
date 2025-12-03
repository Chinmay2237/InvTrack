import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../ui/screens/products/widgets/product_list_layout.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _isGridView = true;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            title: const Text('Inventory'),
            actions: [
              IconButton(
                icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => context.go('/add-product'),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SearchBar(
                  leading: const Icon(Icons.search),
                  hintText: 'Search products...',
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
              ),
            ),
          ),
          ProductListLayout(
            isGridView: _isGridView,
            searchQuery: _searchQuery,
          ),
        ],
      ),
    );
  }
}
