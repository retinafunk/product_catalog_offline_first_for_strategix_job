/// Central constants for the product feature data layer.
class AppConstants {
  const AppConstants._();

  // ── Hive box names ────────────────────────────────────────────────────
  static const String productsBoxName = 'products_box';
  static const String favoritesBoxName = 'favorites_box';

  // ── Hive cache keys ────────────────────────────────────────────────────
  static const String productsCacheKey = 'cached_products';
  static const String favoritesKey = 'favorite_ids';

  // ── DummyJSON REST API ────────────────────────────────────────────────
  static const String baseUrl = 'https://dummyjson.com';
  static const String productsPath = '/products';
  static const int productsLimit = 30;

  // ── Network timeouts ─────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}

