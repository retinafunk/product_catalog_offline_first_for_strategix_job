import '../entities/product_entity.dart';

/// Domain-layer contract for product data access.
abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
}

