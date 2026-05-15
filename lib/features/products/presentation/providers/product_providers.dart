import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain-logic/entities/product_entity.dart';

final productListProvider =
	AutoDisposeAsyncNotifierProvider<ProductListNotifier, ProductListResult>(
  ProductListNotifier.new,
);

class ProductListNotifier extends AutoDisposeAsyncNotifier<ProductListResult> {
  @override
  Future<ProductListResult> build() async {
	// Placeholder until repository wiring is added.
	return const ProductListResult(products: []);
  }

  Future<void> refresh() async {
	state = const AsyncLoading<ProductListResult>();
	state = await AsyncValue.guard(() => build());
  }
}

class ProductListResult {
  const ProductListResult({required this.products});

  final List<Product> products;
}

