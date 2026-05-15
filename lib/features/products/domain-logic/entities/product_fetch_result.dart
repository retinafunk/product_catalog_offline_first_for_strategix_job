import 'product_entity.dart';

/// Pairs the fetched [products] list with an [isOffline] flag so the UI can
/// show a meaningful indicator skeleton when data is served from the local cache.
class ProductListFetchResult {
  const ProductListFetchResult({
    required this.products,
    this.isOffline = false,
  });

  final List<Product> products;

  /// remote request was unavailable or failed.
  /// `true` when this result was served from the local cache because the

  final bool isOffline;

  ProductListFetchResult copyWith({
    List<Product>? products,
    bool? isOffline,
  }) =>
      ProductListFetchResult(
        products: products ?? this.products,
        isOffline: isOffline ?? this.isOffline,
      );
}

