import '../../common/errors/app_exception.dart';
import '../../common/network/connectivity_service.dart';
import '../../domain/entities/product_fetch_result.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local_product_datasource.dart';
import '../datasources/remote_product_datasource.dart';

/// Concrete implementation of [ProductRepository].
///
/// ### Offline-first strategy
/// 1. Check connectivity.
/// 2. **Online** → fetch fresh data from the remote API, persist to cache,
///    return with `isOffline: false`.
/// 3. **Online but request fails** → fall back to cache with `isOffline: true`.
/// 4. **Offline** → return from cache with `isOffline: true`.
/// 5. **No cache in any failure scenario** → throw [NetworkException].
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required RemoteProductDatasource remote,
    required LocalProductDatasource local,
    required ConnectivityService connectivity,
  })  : _remote = remote,
        _local = local,
        _connectivity = connectivity;

  final RemoteProductDatasource _remote;
  final LocalProductDatasource _local;
  final ConnectivityService _connectivity;

  @override
  Future<ProductFetchResult> getProducts() async {
    final isOnline = await _connectivity.isConnected;

    if (isOnline) {
      try {
        final models = await _remote.fetchProducts();
        await _local.cacheProducts(models);
        return ProductFetchResult(
          products: models.map((m) => m.toEntity()).toList(),
          isOffline: false,
        );
      } catch (_) {
        return _fromCache();
      }
    } else {
      return _fromCache();
    }
  }

  @override
  Future<ProductFetchResult> refreshProducts() async {
    try {
      final models = await _remote.fetchProducts();
      await _local.cacheProducts(models);
      return ProductFetchResult(
        products: models.map((m) => m.toEntity()).toList(),
        isOffline: false,
      );
    } catch (_) {
      return _fromCache();
    }
  }

  Future<ProductFetchResult> _fromCache() async {
    final cached = await _local.getCachedProducts();
    if (cached == null || cached.isEmpty) {
      throw const NetworkException();
    }
    return ProductFetchResult(
      products: cached.map((m) => m.toEntity()).toList(),
      isOffline: true,
    );
  }
}

