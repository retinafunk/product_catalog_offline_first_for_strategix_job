import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../common/constants/app_constants.dart';
import '../../common/network/connectivity_service.dart';
import '../../data/datasources/favorites_local_datasource.dart';
import '../../data/datasources/local_image_cache_datasource.dart';
import '../../data/datasources/local_product_datasource.dart';
import '../../data/datasources/remote_product_datasource.dart';
import '../../data/repositories/image_cache_service.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';

// ── Hive boxes ────────────────────────────────────────────────────────────────

final productsBoxProvider = Provider<Box<dynamic>>(
  (ref) => Hive.box(AppConstants.productsBoxName),
);

final favoritesBoxProvider = Provider<Box<dynamic>>(
  (ref) => Hive.box(AppConstants.favoritesBoxName),
);

final imagesBoxProvider = Provider<Box<dynamic>>(
  (ref) => Hive.box(AppConstants.imagesBoxName),
);

// ── Connectivity ──────────────────────────────────────────────────────────────

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService(),
);

// ── Data sources ──────────────────────────────────────────────────────────────

final remoteProductDatasourceProvider = Provider<RemoteProductDatasource>(
  (ref) => RemoteProductDatasourceImpl(),
);

final localProductDatasourceProvider = Provider<LocalProductDatasource>(
  (ref) => LocalProductDatasourceImpl(ref.watch(productsBoxProvider)),
);

final localImageCacheDatasourceProvider = Provider<LocalImageCacheDatasource>(
  (ref) => LocalImageCacheDatasourceImpl(ref.watch(imagesBoxProvider)),
);

final favoritesLocalDatasourceProvider = Provider<FavoritesLocalDatasource>(
  (ref) =>
      FavoritesLocalDatasourceImpl(ref.watch(favoritesBoxProvider)),
);

final imageCacheServiceProvider = Provider<ImageCacheService>(
  (ref) => ImageCacheService(
    local: ref.watch(localImageCacheDatasourceProvider),
  ),
);

// ── Repository ────────────────────────────────────────────────────────────────

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(
    remote: ref.watch(remoteProductDatasourceProvider),
    local: ref.watch(localProductDatasourceProvider),
    connectivity: ref.watch(connectivityServiceProvider),
  ),
);

