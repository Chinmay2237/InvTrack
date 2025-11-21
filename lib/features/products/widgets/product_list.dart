import 'package:flutter/material.dart';
import 'package:invtrack/core/services/firestore_service.dart';
import 'package:invtrack/features/products/models/product.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Added for date formatting

class ProductList extends StatefulWidget {
  final String category;
  const ProductList({super.key, required this.category});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterProducts(_searchController.text);
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = _allProducts;
      });
      return;
    }

    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final nameMatches = product.name.toLowerCase().contains(lowerCaseQuery);
        final serialNumberMatches = product.serialNumber.toLowerCase().contains(lowerCaseQuery);
        final assignedToMatches = product.assignedTo.toLowerCase().contains(lowerCaseQuery);
        return nameMatches || serialNumberMatches || assignedToMatches;
      }).toList();
    });
  }

  Future<void> _deleteProduct(BuildContext context, String productId) async {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete) {
      try {
        await firestoreService.deleteProduct(productId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search by Name, Serial, or Assigned To',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Product>>(
            stream: firestoreService.getProducts(widget.category),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              _allProducts = snapshot.data ?? [];
              _filterProducts(_searchController.text); // Re-filter when data changes

              if (_filteredProducts.isEmpty) {
                return const Center(child: Text('No products found.'));
              }

              return SingleChildScrollView(
                child: PaginatedDataTable(
                  header: Text('${widget.category} Inventory'),
                  rowsPerPage: 10,
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Serial Number')),
                    DataColumn(label: Text('Assigned To')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Cost')),
                    DataColumn(label: Text('Created At')),
                    DataColumn(label: Text('Actions')),
                  ],
                  source: _ProductDataSource(
                    _filteredProducts,
                    context,
                    widget.category,
                    _deleteProduct,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProductDataSource extends DataTableSource {
  final List<Product> products;
  final BuildContext context;
  final String category;
  final Function(BuildContext, String) onDelete;

  _ProductDataSource(this.products, this.context, this.category, this.onDelete);

  @override
  DataRow? getRow(int index) {
    if (index >= products.length) {
      return null;
    }
    final product = products[index];
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm'); // Date formatter

    return DataRow(
      onSelectChanged: (selected) {
        if (selected ?? false) {
          context.go('/$category/details/${product.id}');
        }
      },
      cells: [
        DataCell(Text(product.name)),
        DataCell(Text(product.serialNumber)),
        DataCell(Text(product.assignedTo)),
        DataCell(Text(product.category)),
        DataCell(Text('\$${product.cost.toStringAsFixed(2)}')),
        DataCell(Text(product.createdAt != null ? dateFormat.format(product.createdAt!) : 'N/A')), // Formatted date
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () {
                  context.go('/$category/edit/${product.id}');
                },
                tooltip: 'Edit Product',
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                onPressed: () => onDelete(context, product.id),
                tooltip: 'Delete Product',
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => products.length;

  @override
  int get selectedRowCount => 0;
}