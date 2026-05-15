/// Central constants for the product feature data layer.
class AppConstants {
  const AppConstants._();

  // ── Hive cache ────────────────────────────────────────────────────────
  static const String productsCacheKey = 'cached_products';

  // ── DummyJSON REST API ────────────────────────────────────────────────
  static const String baseUrl = 'https://dummyjson.com';
  static const String productsPath = '/products';
  static const int productsLimit = 30;

  // ── Network timeouts ─────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}

