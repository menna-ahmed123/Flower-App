import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:flower_app/features/commerce/domain/use_cases/search_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_use_case_test.mocks.dart';

@GenerateMocks([CommerceRepo])
void main() {
  provideDummy<BaseResponse<List<ProductEntity>>>(
    SuccessResponse<List<ProductEntity>>([]),
  );

  late MockCommerceRepo repo;
  late SearchUseCase useCase;

  setUp(() {
    repo = MockCommerceRepo();
    useCase = SearchUseCase(repo);
  });

  final products = [
    const ProductEntity(
      id: '1',
      name: 'red rose',
      imageUrl: 'image1',
      price: 100,
      discountedPrice: 90,
      discountPercent: 10,
      inStock: true,
    ),
    const ProductEntity(
      id: '2',
      name: 'White Lily',
      imageUrl: 'image2',
      price: 150,
      discountedPrice: 150,
      inStock: true,
    ),
    const ProductEntity(
      id: '3',
      name: 'Red Tulip',
      imageUrl: 'image3',
      price: 120,
      discountedPrice: 110,
      discountPercent: 8,
      inStock: true,
    ),
  ];

  test('returns products matching the search query', () async {
    when(
      repo.searchProducts(query: 'red rose'),
    ).thenAnswer((_) async => SuccessResponse(products));

    final result = await useCase(query: 'red rose');

    expect(result, isA<SuccessResponse<List<ProductEntity>>>());

    final data = (result as SuccessResponse<List<ProductEntity>>).data;

    expect(data, [products[0]]);
  });

  test('matches products regardless of query casing', () async {
    when(
      repo.searchProducts(query: 'red'),
    ).thenAnswer((_) async => SuccessResponse(products));

    final result = await useCase(query: 'red');

    expect(result, isA<SuccessResponse<List<ProductEntity>>>());

    final data = (result as SuccessResponse<List<ProductEntity>>).data;

    expect(data, [products[0], products[2]]);
  });

  test('returns empty list when no products match', () async {
    when(
      repo.searchProducts(query: 'orchid'),
    ).thenAnswer((_) async => SuccessResponse(products));

    final result = await useCase(query: 'orchid');

    expect(result, isA<SuccessResponse<List<ProductEntity>>>());

    final data = (result as SuccessResponse<List<ProductEntity>>).data;

    expect(data, isEmpty);
  });

  test('trims whitespace from query before filtering', () async {
    when(
      repo.searchProducts(query: 'red'),
    ).thenAnswer((_) async => SuccessResponse(products));

    final result = await useCase(query: '  red  ');

    expect(result, isA<SuccessResponse<List<ProductEntity>>>());

    final data = (result as SuccessResponse<List<ProductEntity>>).data;

    expect(data, [products[0], products[2]]);
    verify(repo.searchProducts(query: 'red')).called(1);
  });
}
