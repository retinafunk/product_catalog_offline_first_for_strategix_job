import '../entities/product_fetch_result.dart';

/// Defines the contract that any product repository implementation must fulfil.
/// Keeping this in the domain layer means the presentation layer depends only
/// on the abstraction, not on any specific infrastructure detail.
abstract class ProductRepository {
  /// Returns products from the best available source (remote → cache fallback).
  /// Sets [ProductFetchResult.isOffline] to `true` when the result is stale.
  Future<ProductFetchResult> getProducts();

  /// Forces a fresh remote fetch, caches the result, and falls back to the
  /// local cache if the request fails.
  Future<ProductFetchResult> refreshProducts();
}

