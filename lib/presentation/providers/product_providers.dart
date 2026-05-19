import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/product_fetch_result.dart';
import 'infrastructure_providers.dart';

/// Notifier that owns the product list UI state.
///
/// `build()` is called once on first watch; subsequent refreshes update
/// [state] in-place so the UI keeps showing stale data while the request is
/// in flight.
class ProductListNotifier extends AsyncNotifier<ProductFetchResult> {
  @override
  Future<ProductFetchResult> build() async {
    return ref.read(productRepositoryProvider).getProducts();
  }

  /// Triggers a remote refresh without wiping the currently displayed list.
  /// The [RefreshIndicator] spinner handles the visual loading state.
  Future<void> refresh() async {
    final result = await AsyncValue.guard(
      () => ref.read(productRepositoryProvider).refreshProducts(),
    );
    state = result;
  }
}

/// Provides the product list as an [AsyncValue<ProductFetchResult>].
final productListProvider =
    AsyncNotifierProvider<ProductListNotifier, ProductFetchResult>(
  ProductListNotifier.new,
);

/// Convenience provider that looks up a single product by [id] from the
/// already-loaded list so the detail screen doesn't need a separate request.
final productByIdProvider = Provider.family<
    AsyncValue<ProductFetchResult>, int>((ref, id) {
  return ref.watch(productListProvider);
});

