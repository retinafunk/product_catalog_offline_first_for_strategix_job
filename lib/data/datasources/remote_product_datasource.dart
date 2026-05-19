import 'package:dio/dio.dart';

import '../../common/constants/app_constants.dart';
import '../../common/errors/app_exception.dart';
import '../models/product_model.dart';

/// Contract for the remote product data source.
abstract class RemoteProductDatasource {
  Future<List<ProductModel>> fetchProducts({
    int limit = AppConstants.productsLimit,
    int skip = 0,
  });
}

/// Fetches products from the DummyJSON REST API.
class RemoteProductDatasourceImpl implements RemoteProductDatasource {
  RemoteProductDatasourceImpl({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConstants.baseUrl,
                connectTimeout: AppConstants.connectTimeout,
                receiveTimeout: AppConstants.receiveTimeout,
              ),
            );

  final Dio _dio;

  @override
  Future<List<ProductModel>> fetchProducts({
    int limit = AppConstants.productsLimit,
    int skip = 0,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        AppConstants.productsPath,
        queryParameters: {'limit': limit, 'skip': skip},
      );

      final data = response.data;
      if (data == null) throw const ServerException('Empty response from server.');

      final productsJson = data['products'] as List<dynamic>?;
      if (productsJson == null) {
        throw const ServerException('Unexpected response format.');
      }

      return productsJson
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException(e.message ?? 'Connection failed.');
      }
      throw ServerException(e.message ?? 'Server error.');
    }
  }
}

