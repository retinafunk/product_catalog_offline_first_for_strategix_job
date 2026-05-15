import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_catalog_offline_first_for_strategix_job/features/products/data/sources/mock/favorites_local_datasource.dart';
import 'package:product_catalog_offline_first_for_strategix_job/features/products/data/providers/favorites_provider.dart';
import 'package:product_catalog_offline_first_for_strategix_job/features/products/data/providers/infrastructure_providers.dart';

// ── Mock ──────────────────────────────────────────────────────────────────────

class MockFavoritesLocalDatasource extends Mock
    implements FavoritesLocalDatasource {}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late MockFavoritesLocalDatasource mockDatasource;
  late ProviderContainer container;

  setUp(() {
    mockDatasource = MockFavoritesLocalDatasource();
    when(() => mockDatasource.getFavorites()).thenReturn({});
    when(() => mockDatasource.saveFavorites(any())).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        favoritesLocalDatasourceProvider.overrideWithValue(mockDatasource),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('initial state is an empty set when no favorites are persisted', () {
    final favorites = container.read(favoritesProvider);
    expect(favorites, isEmpty);
  });

  test('initial state reflects persisted favorites', () {
    when(() => mockDatasource.getFavorites()).thenReturn({1, 2, 3});

    final freshContainer = ProviderContainer(
      overrides: [
        favoritesLocalDatasourceProvider.overrideWithValue(mockDatasource),
      ],
    );
    addTearDown(freshContainer.dispose);

    final favorites = freshContainer.read(favoritesProvider);
    expect(favorites, {1, 2, 3});
  });

  test('toggle adds a product id that is not yet a favorite', () {
    container.read(favoritesProvider.notifier).toggle(42);

    expect(container.read(favoritesProvider), contains(42));
    verify(() => mockDatasource.saveFavorites({42})).called(1);
  });

  test('toggle removes a product id that is already a favorite', () {
    when(() => mockDatasource.getFavorites()).thenReturn({42});

    final freshContainer = ProviderContainer(
      overrides: [
        favoritesLocalDatasourceProvider.overrideWithValue(mockDatasource),
      ],
    );
    addTearDown(freshContainer.dispose);

    freshContainer.read(favoritesProvider.notifier).toggle(42);

    expect(freshContainer.read(favoritesProvider), isNot(contains(42)));
    verify(() => mockDatasource.saveFavorites({})).called(1);
  });

  test('isFavorite returns correct bool', () {
    container.read(favoritesProvider.notifier).toggle(7);

    final notifier = container.read(favoritesProvider.notifier);
    expect(notifier.isFavorite(7), isTrue);
    expect(notifier.isFavorite(99), isFalse);
  });
}
