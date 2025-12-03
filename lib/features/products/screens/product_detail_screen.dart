import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/features/products/providers/product_provider.dart';
import 'package:myapp/features/assign/providers/assign_provider.dart';
import 'package:myapp/features/products/widgets/stock_status_tag.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/core/theme/app_text.dart';
import 'package:myapp/core/theme/app_spacing.dart';
import 'package:myapp/features/assign/models/handover_type.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myapp/features/assign/models/assignment_history.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  void _showAssignDialog(BuildContext context, ProductProvider productProvider) {
    final product = productProvider.findById(productId);
    final assignProvider = Provider.of<AssignProvider>(context, listen: false);
    final TextEditingController employeeNameController = TextEditingController();
    final TextEditingController projectNameController = TextEditingController();
    HandoverType selectedHandoverType = HandoverType.Permanent;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Handover Product'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: employeeNameController,
                      decoration: const InputDecoration(labelText: 'Employee Name'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<HandoverType>(
                      value: selectedHandoverType,
                      decoration: const InputDecoration(labelText: 'Handover Type'),
                      items: HandoverType.values.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type.toString().split('.').last));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedHandoverType = value;
                          });
                        }
                      },
                    ),
                    if (selectedHandoverType == HandoverType.Temporary)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextField(
                          controller: projectNameController,
                          decoration: const InputDecoration(labelText: 'Project Name'),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                TextButton(
                  child: const Text('Handover'),
                  onPressed: () {
                    if (employeeNameController.text.isNotEmpty) {
                      assignProvider.assignProduct(
                        product,
                        employeeNameController.text,
                        selectedHandoverType,
                        projectName: projectNameController.text.isNotEmpty ? projectNameController.text : null,
                      );
                      Navigator.of(ctx).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final product = productProvider.findById(productId);
    final assignProvider = Provider.of<AssignProvider>(context);
    final bool isAssigned = assignProvider.isAssigned(productId);
    final history = assignProvider.history[productId] ?? [];

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            floating: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.name, style: AppText.titleLarge.copyWith(color: Colors.white, shadows: [const Shadow(blurRadius: 10, color: Colors.black45)])),
              background: Hero(
                tag: 'productImage${product.id}',
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 150, color: Colors.white70)),
                ),
              ),
              stretchModes: const [StretchMode.zoomBackground],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: AppSpacing.edgeInsetsAll24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(product.name, style: AppText.headlineMedium.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: AppSpacing.space16),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppText.headlineMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space8),
                    Text(product.category, style: AppText.titleMedium.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: AppSpacing.space24),
                    Row(
                      children: [
                        Text('Stock:', style: AppText.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(width: AppSpacing.space8),
                        StockStatusTag(quantity: product.quantity),
                        const Spacer(),
                        Text('${product.quantity} units', style: AppText.titleMedium),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space16),
                    if (isAssigned)
                      const Chip(
                        label: Text('Assigned'),
                        backgroundColor: AppColors.primary,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    const SizedBox(height: AppSpacing.space24),
                    const Divider(),
                    const SizedBox(height: AppSpacing.space24),
                    Text('Description', style: AppText.titleLarge.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.space16),
                    Text(product.description, style: AppText.bodyLarge.copyWith(height: 1.6, color: AppColors.textPrimary)),
                    const SizedBox(height: AppSpacing.space24),
                    const Divider(),
                    const SizedBox(height: AppSpacing.space24),
                    Text('Handover History', style: AppText.titleLarge.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.space16),
                    history.isEmpty
                        ? const Text('No handover history for this product.')
                        : CarouselSlider(
                            options: CarouselOptions(
                              height: 150,
                              viewportFraction: 0.8,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              reverse: false,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: history.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('To: ${i.employeeName}', style: AppText.titleMedium),
                                          Text('Type: ${i.handoverType.toString().split('.').last}'),
                                          if (i.projectName != null)
                                            Text('Project: ${i.projectName}'),
                                          Text('Date: ${i.handoverDate.toLocal().toString().split(' ')[0]}'),
                                          if(i.returnDate != null)
                                            Text('Return Date: ${i.returnDate!.toLocal().toString().split(' ')[0]}'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                    const SizedBox(height: 100), // Extra space at the bottom
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isAssigned ? null : () => _showAssignDialog(context, productProvider),
        label: Text(isAssigned ? 'Assigned' : 'Handover'),
        icon: const Icon(Icons.assignment_ind),
        backgroundColor: isAssigned ? AppColors.grey : AppColors.primary,
      ),
    );
  }
}
