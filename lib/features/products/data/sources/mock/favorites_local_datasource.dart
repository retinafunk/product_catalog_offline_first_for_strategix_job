import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';


abstract class FavoritesLocalDatasource {
  Set<int> getFavorites();
  Future<void> saveFavorites(Set<int> favorites);
}

///  and retrieves & persists / cache favorite product IDs in a Hive box.
/// Hive supports storing [List] natively so no JSON serialisation is needed.
class FavoritesLocalDatasourceImpl implements FavoritesLocalDatasource {
  FavoritesLocalDatasourceImpl(this._box);

  final Box<dynamic> _box;

  @override
  Set<int> getFavorites() {
    try {
      final raw = _box.get(AppConstants.favoritesKey);
      if (raw == null) return {};
      return (raw as List<dynamic>).cast<int>().toSet();
    } catch (e) {
      throw CacheException('Failed to read favorites: $e');
    }
  }

  @override
  Future<void> saveFavorites(Set<int> favorites) async {
    try {
      await _box.put(AppConstants.favoritesKey, favorites.toList());
    } catch (e) {
      throw CacheException('Failed to write favorites: $e');
    }
  }
}

