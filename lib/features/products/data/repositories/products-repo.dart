class ProductsRepository
{
  final ProductsApi api = ProductsApi();
  late final cachedProductsInLocalStore localCache;

  get freshNewProducts => null;

  Future<List<Product>> getAllProducts() async {
    try {
      final freshNewProducts = await api.fetchProducts();

      await cachedProductsInLocalStore.saveProducts(freshNewProducts);

      return freshNewProducts;
    } catch (_) {
      final cachedProductsInLocalStore = await freshNewProducts.getProducts();

      if (cachedProductsInLocalStore.isNotEmpty) {
        return cachedProductsInLocalStore;
      }

      rethrow;
    }
  }

}

class Product {
}

class cachedProductsInLocalStore {
  static saveProducts(remoteProducts) {}
}

class ProductsApi {
  fetchProducts() {}
}
