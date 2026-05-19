import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';

/// Contract for locally cached image bytes.
abstract class LocalImageCacheDatasource {
  Future<Uint8List?> getImageBytes(String url);
  Future<void> putImageBytes(String url, Uint8List bytes);
}

/// Stores base64-encoded image bytes in a Hive box keyed by the image URL.
class LocalImageCacheDatasourceImpl implements LocalImageCacheDatasource {
  LocalImageCacheDatasourceImpl(this._box);

  final Box<dynamic> _box;

  @override
  Future<Uint8List?> getImageBytes(String url) async {
    if (url.isEmpty) return null;
    final raw = _box.get(url);
    if (raw is! String || raw.isEmpty) return null;

    try {
      return base64Decode(raw);
    } catch (_) {
      await _box.delete(url);
      return null;
    }
  }

  @override
  Future<void> putImageBytes(String url, Uint8List bytes) async {
    if (url.isEmpty || bytes.isEmpty) return;
    final encoded = base64Encode(bytes);
    await _box.put(url, encoded);
  }
}

