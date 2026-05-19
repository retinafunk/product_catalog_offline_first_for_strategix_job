import 'product.dart';

/// Pairs the fetched [products] list with an [isOffline] flag so the UI can
/// show a meaningful indicator when data is served from the local cache.
class ProductFetchResult {
  const ProductFetchResult({
    required this.products,
    this.isOffline = false,
  });

  final List<Product> products;

  /// `true` when this result was served from the local cache because the
  /// remote request was unavailable or failed.
  final bool isOffline;

  ProductFetchResult copyWith({
    List<Product>? products,
    bool? isOffline,
  }) =>
      ProductFetchResult(
        products: products ?? this.products,
        isOffline: isOffline ?? this.isOffline,
      );
}

