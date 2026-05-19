import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_catalog_offline_first_for_strategix_job/common/errors/app_exception.dart';
    ?.map((e) => e as String)

import 'package:product_catalog_offline_first_for_strategix_job/features/products/data/models/product_model.dart';
import 'package:product_catalog_offline_first_for_strategix_job/features/products/data/repositories/product_repository_impl.dart';
import 'package:product_catalog_offline_first_for_strategix_job/features/products/data/sources/mock/local_product_datasource.dart';
import 'package:product_catalog_offline_first_for_strategix_job/features/products/data/sources/mock/remote_product_datasource.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────

class MockRemoteProductDatasource extends Mock
    implements RemoteProductDatasource {}

class MockLocalProductDatasource extends Mock
    implements LocalProductDatasource {}

class MockConnectivityService extends Mock implements ConnectivityService {}

// ── Fixtures ──────────────────────────────────────────────────────────────────

final tProductModels = [
  ProductModel(
    id: 1,
    productName: 'Widget A',
    productBrand: 'Acme',
    description: 'A useful widget.',
    category: 'electronics',
    priceWithTaxes: 29.99,
    priceWithoutTaxes: 24.99,
    thumbnailImage: 'https://example.com/a.jpg',
    priceKgOrLitre4Compare: 1.23,
    productImages: ['https://example.com/a.jpg'],
    tags: ['gadget'],
  ),
];

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteProductDatasource mockRemote;
  late MockLocalProductDatasource mockLocal;
  late MockConnectivityService mockConnectivity;

  setUp(() {
    mockRemote = MockRemoteProductDatasource();
    mockLocal = MockLocalProductDatasource();
    mockConnectivity = MockConnectivityService();

    repository = ProductRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      connectivity: mockConnectivity,
    );
  });

  group('ProductRepositoryImpl.getAllProducts', () {
    test(
        'returns fresh data when online and remote fetch succeeds', () async {
      when(() => mockConnectivity.isOnline).thenAnswer((_) async => true);
      when(() => mockRemote.fetchProducts())
          .thenAnswer((_) async => tProductModels);
      when(() => mockLocal.cacheProducts(any())).thenAnswer((_) async {});

      final result = await repository.getAllProducts();

      expect(result.length, 1);
      expect(result.first.productName, 'Widget A');
      verify(() => mockLocal.cacheProducts(tProductModels)).called(1);
    });

    test('returns cached data when device is offline', () async {
      when(() => mockConnectivity.isOnline).thenAnswer((_) async => false);
      when(() => mockLocal.getCachedProducts())
          .thenAnswer((_) async => tProductModels);

      final result = await repository.getAllProducts();

      expect(result.length, 1);
      verifyNever(() => mockRemote.fetchProducts());
    });

    test('falls back to cache when online but remote throws', () async {
      when(() => mockConnectivity.isOnline).thenAnswer((_) async => true);
      when(() => mockRemote.fetchProducts())
          .thenThrow(const NetworkException('offline'));
      when(() => mockLocal.getCachedProducts())
          .thenAnswer((_) async => tProductModels);

      final result = await repository.getAllProducts();

      expect(result.length, 1);
      verify(() => mockLocal.getCachedProducts()).called(1);
    });

    test('returns empty list when offline and cache is empty', () async {
      when(() => mockConnectivity.isOnline).thenAnswer((_) async => false);
      when(() => mockLocal.getCachedProducts()).thenAnswer((_) async => null);

      final result = await repository.getAllProducts();

      expect(result, isEmpty);
    });
  });
}
