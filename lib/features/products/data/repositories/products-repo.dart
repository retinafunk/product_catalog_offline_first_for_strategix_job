import '../models/productModel.dart';
import '../../domain-logic/entities/product_entity.dart';

abstract class ProductsApi {
  Future<List<ProductModel>> fetchProducts();
}

abstract class ProductsLocalCache {
  Future<void> saveProducts(List<ProductModel> products);
  Future<List<ProductModel>> getProducts();
}

class ProductsRepository {
  const ProductsRepository({
    required this.api,
    required this.localCache,
  });

  final ProductsApi api;
  final ProductsLocalCache localCache;

  Future<List<Product>> getAllProducts() async {
    try {
      final freshProducts = await api.fetchProducts();

      await localCache.saveProducts(freshProducts);

      return freshProducts.map((product) => product.toEntity()).toList();
    } catch (_) {
      final cachedProducts = await localCache.getProducts();

      if (cachedProducts.isNotEmpty) {
        return cachedProducts.map((product) => product.toEntity()).toList();
      }

      rethrow;
    }
  }
}
