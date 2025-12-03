import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/features/products/providers/product_provider.dart';
import 'package:myapp/features/products/widgets/product_list_item.dart';
import 'package:myapp/features/products/screens/add_product_screen.dart';
import 'package:myapp/features/products/models/stock_filter.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/core/theme/app_text.dart';
import 'package:myapp/core/theme/app_spacing.dart';

class UserProductsScreen extends StatefulWidget {
  const UserProductsScreen({super.key});

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  Future<void>? _fetchProductsFuture;
  StockFilter _selectedFilter = StockFilter.all;

  @override
  void initState() {
    super.initState();
    _fetchProductsFuture = _fetchProducts(context);
  }

  Future<void> _fetchProducts(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchAndSetProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(theme),
          Expanded(
            child: FutureBuilder(
              future: _fetchProductsFuture,
              builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => _fetchProducts(context),
                      child: Consumer<ProductProvider>(
                        builder: (ctx, productsData, _) => _buildProductGrid(productsData),
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AddProductScreen()));
        },
        label: const Text('Add Product'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: AppSpacing.edgeInsetsAll16,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Products...',
          prefixIcon: const Icon(Icons.search),
        ),
        onChanged: (value) {
          Provider.of<ProductProvider>(context, listen: false).searchProducts(value);
        },
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    return Padding(
      padding: AppSpacing.edgeInsetsSymmetricH16,
      child: SizedBox(
        height: 40,
        child: ListView( 
          scrollDirection: Axis.horizontal,
          children: StockFilter.values.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilterChip(
                label: Text(filter.name[0].toUpperCase() + filter.name.substring(1)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                    Provider.of<ProductProvider>(context, listen: false).setFilter(filter);
                  }
                },
                selectedColor: theme.chipTheme.selectedColor,
                labelStyle: isSelected ? AppText.bodyMedium.copyWith(color: theme.chipTheme.labelStyle?.color) : AppText.bodyMedium,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProductGrid(ProductProvider productsData) {
    final products = productsData.items;
    if (products.isEmpty) {
      return Center(
        child: Text('No products found. Try a different search or filter.', style: AppText.bodyLarge.copyWith(color: AppColors.textSecondary)),
      );
    }

    return GridView.builder(
      padding: AppSpacing.edgeInsetsAll16,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppSpacing.space16,
        mainAxisSpacing: AppSpacing.space16,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductListItem(product: products[i]),
    );
  }
}
