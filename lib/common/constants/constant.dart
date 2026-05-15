/// App-wide constants — single source of truth for magic strings and numbers.
class AppConstants {
  AppConstants._();

  // ── API ──────────────────────────────────────────────────────────────────
  static const String baseUrl = 'https://dummyjson.com';
  static const String productsPath = '/products';
  static const int productsLimit = 30;

  // ── Hive box names ────────────────────────────────────────────────────────
  static const String productsBoxName = 'products_box';
  static const String favoritesBoxName = 'favorites_box';

  // ── Hive keys ─────────────────────────────────────────────────────────────
  static const String productsCacheKey = 'products_cache';
  static const String favoritesKey = 'favorite_ids';

  // ── Timeouts ──────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
