import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController imageUrlController;
  final FocusNode priceFocusNode;
  final FocusNode descriptionFocusNode;
  final FocusNode imageUrlFocusNode;
  final String? initialImageUrl;
  final Function(String) onImageUrlChanged;

  const ProductFormWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.imageUrlController,
    required this.priceFocusNode,
    required this.descriptionFocusNode,
    required this.imageUrlFocusNode,
    this.initialImageUrl,
    required this.onImageUrlChanged,
  });

  @override
  _ProductFormWidgetState createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
    widget.imageUrlController.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    widget.imageUrlController.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl() {
    if (mounted) {
      setState(() {
        _imageUrl = widget.imageUrlController.text;
      });
      widget.onImageUrlChanged(_imageUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextFormField(
            controller: widget.nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(widget.priceFocusNode);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.priceController,
            decoration: const InputDecoration(
              labelText: 'Price',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            textInputAction: TextInputAction.next,
            focusNode: widget.priceFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(widget.descriptionFocusNode);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a price.';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number.';
              }
              if (double.parse(value) <= 0) {
                return 'Please enter a number greater than zero.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            focusNode: widget.descriptionFocusNode,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description.';
              }
              if (value.length < 10) {
                return 'Should be at least 10 characters long.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(top: 8, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                child: _imageUrl == null || _imageUrl!.isEmpty
                    ? const Center(child: Text('Enter a URL'))
                    : FittedBox(
                        child: Image.network(
                          _imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Text('Invalid Image URL')),
                        ),
                      ),
              ),
              Expanded(
                child: TextFormField(
                  controller: widget.imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  focusNode: widget.imageUrlFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL.';
                    }
                    if (!value.startsWith('http') &&
                        !value.startsWith('https')) {
                      return 'Please enter a valid URL.';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
