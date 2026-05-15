import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../domain-logic/entities/product_fetch_result.dart';
import 'infrastructure_providers.dart';

/// Notifier that owns the product list UI state.
///
/// `build()` is called once on first watch; subsequent refreshes update
/// [state] in-place so the UI keeps showing stale data while the request is
/// in flight.
class ProductListNotifier extends AsyncNotifier<ProductListFetchResult> {
  @override
  Future<ProductListFetchResult> build() async {
    final products = await ref.read(productRepositoryProvider).getAllProducts();
    return ProductListFetchResult(products: products);
  }

  /// Triggers a remote refresh without wiping the currently displayed list.
  /// The [RefreshIndicator] spinner handles the visual loading state.
  Future<void> refresh() async {
    state = const AsyncLoading<ProductListFetchResult>();
    state = await AsyncValue.guard(() async {
      final products =
          await ref.read(productRepositoryProvider).getAllProducts();
      return ProductListFetchResult(products: products);
    });
  }
}

/// Provides the product list as an [AsyncValue<ProductListFetchResult>].
final productListProvider =
    AsyncNotifierProvider<ProductListNotifier, ProductListFetchResult>(
  ProductListNotifier.new,
);

/// Convenience provider that looks up a single product by [id] from the
/// already-loaded list so the detail screen doesn't need a separate request.
final productByIdProvider = Provider.family<
    AsyncValue<ProductListFetchResult>, int>((ref, id) {
  return ref.watch(productListProvider);
});
