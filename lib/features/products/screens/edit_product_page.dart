import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/core/services/firestore_service.dart';
import 'package:invtrack/features/products/models/product.dart';
import 'package:invtrack/features/products/widgets/product_form.dart';
import 'package:provider/provider.dart';

class EditProductPage extends StatefulWidget {
  final String productId;

  const EditProductPage({super.key, required this.productId});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late Future<Product?> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _fetchProduct();
  }

  Future<Product?> _fetchProduct() {
    final firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    return firestoreService.getProductById(widget.productId);
  }

  Future<void> _onSave(Product product, File? imageFile) async {
    final firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    try {
      String? imageUrl = product.imageUrl;
      if (imageFile != null) {
        final imageData = await imageFile.readAsBytes();
        final imageName = imageFile.path.split('/').last;
        imageUrl = await firestoreService.uploadProductImage(
            product.id, imageData, imageName);
        if (imageUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to upload image. Please try again.')),
          );
          return;
        }
      }

      final updatedProduct = product.copyWith(imageUrl: imageUrl);
      await firestoreService.updateProduct(updatedProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully')),
      );
      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: FutureBuilder<Product?>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Product not found.'));
          }

          final product = snapshot.data!;

          return ProductForm(
            initialProduct: product,
            onSave: _onSave,
          );
        },
      ),
    );
  }
}
