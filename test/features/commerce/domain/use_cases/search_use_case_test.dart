import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/product_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_cases/search_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_use_case_test.mocks.dart';

@GenerateMocks([ProductUseCase])
void main() {
  provideDummy<BaseResponse<List<ProductEntity>>>(
    SuccessResponse<List<ProductEntity>>([]),
  );

  late MockProductUseCase productUseCase;
  late SearchUseCase useCase;

  setUp(() {
    productUseCase = MockProductUseCase();
    useCase = SearchUseCase(productUseCase);
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
  ];

  test('calls ProductUseCase with the search query', () async {
    when(
      productUseCase(search: 'red rose'),
    ).thenAnswer((_) async => SuccessResponse(products));

    await useCase(query: 'red rose');

    verify(productUseCase(search: 'red rose')).called(1);
  });

  test('returns the products response from ProductUseCase', () async {
    when(
      productUseCase(search: 'red rose'),
    ).thenAnswer((_) async => SuccessResponse(products));

    final response = await useCase(query: 'red rose');

    expect(response, isA<SuccessResponse<List<ProductEntity>>>());
    expect((response as SuccessResponse<List<ProductEntity>>).data, products);
  });

  test('returns the error response from ProductUseCase', () async {
    final error = IgnoreError();

    when(productUseCase(search: 'ldfjl')).thenAnswer(
      (_) async => ErrorResponse<List<ProductEntity>>(appError: error),
    );

    final response = await useCase(query: 'ldfjl');

    expect(response, isA<ErrorResponse<List<ProductEntity>>>());

    expect((response as ErrorResponse<List<ProductEntity>>).appError, error);
  });
}
