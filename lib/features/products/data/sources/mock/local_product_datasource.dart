import 'dart:convert';

import 'package:hive/hive.dart';


import '../../../../../common/constants/app_constants.dart';
import '../../../../../common/errors/app_exception.dart';
import '../../models/product_model.dart';

abstract class LocalProductDatasource {
  Future<List<ProductModel>?> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
}


/// Storing the serialised JSON manually means we don't need Hive code
/// generation (TypeAdapters) while still benefiting from Hive's fast binary
/// storage.
class LocalProductDatasourceImpl implements LocalProductDatasource {
  LocalProductDatasourceImpl(this._box);

  final Box<dynamic> _box;

  @override
  Future<List<ProductModel>?> getCachedProducts() async {
    try {
      final raw = _box.get(AppConstants.productsCacheKey);
      if (raw == null) return null;

      final list = jsonDecode(raw as String) as List<dynamic>;
      return list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to read products from cache: $e');
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final jsonString = jsonEncode(products.map((p) => p.toJson()).toList());
      await _box.put(AppConstants.productsCacheKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to write products to cache: $e');
    }
  }
}

