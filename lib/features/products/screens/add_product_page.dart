import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/core/services/firestore_service.dart';
import 'package:invtrack/features/products/models/product.dart';
import 'package:invtrack/features/products/widgets/product_form.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  Future<void> _onSave(Product product, File? imageFile) async {
    final firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    try {
      String? imageUrl;
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

      final newProduct = product.copyWith(
        imageUrl: imageUrl,
        price: product.price, // Add this line
      );
      await firestoreService.addProduct(newProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully')),
      );
      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: ProductForm(
        onSave: _onSave,
      ),
    );
  }
}
