import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';


import '../../../../common/constants/app_constants.dart';
import '../../../../common//network/connectivity_service.dart';
import '../sources/mock/favorites_local_datasource.dart';
import '../sources/mock/local_product_datasource.dart';
import '../sources/mock/remote_product_datasource.dart';
import '../repositories/product_repository_impl.dart';
import '../../domain-logic/repositories/products-repo.dart';

// ── Hive boxes ────────────────────────────────────────────────────────────────

final productsBoxProvider = Provider<Box<dynamic>>(
  (ref) => Hive.box(AppConstants.productsBoxName),
);

final favoritesBoxProvider = Provider<Box<dynamic>>(
  (ref) => Hive.box(AppConstants.favoritesBoxName),
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

final favoritesLocalDatasourceProvider = Provider<FavoritesLocalDatasource>(
  (ref) =>
      FavoritesLocalDatasourceImpl(ref.watch(favoritesBoxProvider)),
);

// ── Repository ────────────────────────────────────────────────────────────────

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(
    remote: ref.watch(remoteProductDatasourceProvider),
    local: ref.watch(localProductDatasourceProvider),
    connectivity: ref.watch(connectivityServiceProvider),
  ),
);

