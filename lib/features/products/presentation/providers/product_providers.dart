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

/// Derives a single [Product] from [productListProvider] by matching [id].
/// Returns `null` when the list is still loading or the product is not found.
final productByIdProvider =
    Provider.autoDispose.family<Product?, int>((ref, id) {
  return ref
      .watch(productListProvider)
      .valueOrNull
      ?.products
      .cast<Product?>()
      .firstWhere((p) => p?.id == id, orElse: () => null);
});
