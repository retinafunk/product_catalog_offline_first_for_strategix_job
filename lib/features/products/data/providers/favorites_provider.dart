import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'infrastructure_providers.dart';

/// Holds the set of favorited product IDs. Uses a synchronous [Notifier]
/// because the seed value is read from Hive synchronously in [build].
class FavoritesNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() {
    final datasource = ref.read(favoritesLocalDatasourceProvider);
    return datasource.getFavorites();
  }

  /// Adds the [productId] if it's not already a favorite, removes it otherwise.
  /// Persists the updated set to Hive immediately.
  void toggle(int productId) {
    final next = {...state};
    if (next.contains(productId)) {
      next.remove(productId);
    } else {
      next.add(productId);
    }
    state = next;
    // Fire-and-forget; failures are not surfaced to the UI for simplicity.
    ref.read(favoritesLocalDatasourceProvider).saveFavorites(next);
  }

  bool isFavorite(int productId) => state.contains(productId);
}

/// Provides the current set of favorite product IDs.
final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<int>>(
  FavoritesNotifier.new,
);

