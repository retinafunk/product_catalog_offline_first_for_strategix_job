import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_providers.dart';
import '../widgets/product_detail_widget.dart';

class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(productListProvider);
    final product = ref.watch(productByIdProvider(productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: listState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $e'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(productListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (_) {
          if (product == null) {
            return const Center(child: Text('Product not found.'));
          }
          return ProductDetailWidget(product: product);
        },
      ),
    );
  }
}