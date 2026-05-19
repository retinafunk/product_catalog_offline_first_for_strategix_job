import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../common/constants/app_constants.dart';
import '../datasources/local_image_cache_datasource.dart';

/// Fetches and persists images so they can be rendered offline.
class ImageCacheService {
  ImageCacheService({
    required LocalImageCacheDatasource local,
    Dio? dio,
  })  : _local = local,
        _dio = dio ?? Dio();

  final LocalImageCacheDatasource _local;
  final Dio _dio;

  Future<Uint8List?> getOrFetch(String url) async {
    if (url.isEmpty) return null;

    final cached = await _local.getImageBytes(url);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          sendTimeout: AppConstants.connectTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
        ),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) return null;

      final buffer = Uint8List.fromList(bytes);
      await _local.putImageBytes(url, buffer);
      return buffer;
    } catch (_) {
      return null;
    }
  }
}

