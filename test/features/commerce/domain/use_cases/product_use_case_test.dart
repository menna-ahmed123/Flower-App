import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:flower_app/features/commerce/domain/use_cases/product_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'product_use_case_test.mocks.dart';

@GenerateMocks([CommerceRepo])
void main() {
  provideDummy<BaseResponse<List<ProductEntity>>>(
    const SuccessResponse<List<ProductEntity>>([]),
  );

  late MockCommerceRepo commerceRepo;
  late ProductUseCase productUseCase;

  final dummyProducts = [
    const ProductEntity(
      id: '1',
      name: 'Red Rose Bouquet',
      imageUrl: 'https://example.com/rose.jpg',
      price: 25.0,
      discountedPrice: 20.0,
      discountPercent: 20.0,
      inStock: true,
    ),
    const ProductEntity(
      id: '2',
      name: 'White Lily Bunch',
      imageUrl: 'https://example.com/lily.jpg',
      price: 22.5,
      discountedPrice: 22.5,
      discountPercent: 0.0,
      inStock: false,
    ),
  ];

  setUp(() {
    commerceRepo = MockCommerceRepo();
    productUseCase = ProductUseCase(commerceRepo);
  });

  group('ProductUseCase', () {
    test('returns SuccessResponse when repo call succeeds', () async {
      when(commerceRepo.getProducts(
        occasionId: 'occasion-1',
        categoryId: 'category-1',
      ))
          .thenAnswer((_) async => SuccessResponse(dummyProducts));

      final result = await productUseCase(
        occasionId: 'occasion-1',
        categoryId: 'category-1',
      );

      expect(result, isA<SuccessResponse<List<ProductEntity>>>());
      expect((result as SuccessResponse<List<ProductEntity>>).data, dummyProducts);
      verify(commerceRepo.getProducts(
        occasionId: 'occasion-1',
        categoryId: 'category-1',
      )).called(1);
    });

    test('returns ErrorResponse when repo call fails', () async {
      when(commerceRepo.getProducts()).thenAnswer(
        (_) async => ErrorResponse<List<ProductEntity>>(
          appError: BadResponseError('No Found Page'),
        ),
      );

      final result = await productUseCase();

      expect(result, isA<ErrorResponse<List<ProductEntity>>>());
      expect(
        (result as ErrorResponse<List<ProductEntity>>).errorMessage,
        'No Found Page',
      );
      verify(commerceRepo.getProducts()).called(1);
    });
  });
}