import '../../domain-logic/entities/product_entity.dart';
import '../../domain-logic/repositories/products-repo.dart';
import '../core/network/connectivity_service.dart';
import '../sources/mock/local_product_datasource.dart';
import '../sources/mock/remote_product_datasource.dart';

/// Concrete implementation of [ProductRepository].
///
/// Attempts a remote fetch first; on failure or when offline it falls back to
/// the local Hive cache.
class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl({
    required this.remote,
    required this.local,
    required this.connectivity,
  });

  final RemoteProductDatasource remote;
  final LocalProductDatasource local;
  final ConnectivityService connectivity;

  @override
  Future<List<Product>> getAllProducts() async {
    final online = await connectivity.isOnline;

    if (online) {
      try {
        final models = await remote.fetchProducts();
        await local.cacheProducts(models);
        return models.map((m) => m.toEntity()).toList();
      } catch (_) {
        // Fall through to cache on remote failure.
      }
    }

    final cached = await local.getCachedProducts();
    if (cached != null && cached.isNotEmpty) {
      return cached.map((m) => m.toEntity()).toList();
    }

    return [];
  }
}

