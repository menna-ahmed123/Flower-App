import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';

import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/product_details_use_case.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view_model/product_details_event.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view_model/product_details_view_model.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_details_view_model_test.mocks.dart';

@GenerateMocks([ProductDetailsUseCase])
void main() {
  provideDummy<BaseResponse<ProductDetailsEntity>>(
    const SuccessResponse<ProductDetailsEntity>(ProductDetailsEntity()),
  );
  late MockProductDetailsUseCase productDetailsUseCase;
  late ProductDetailsViewModel productDetailsViewModel;

  setUp(() {
    productDetailsUseCase = MockProductDetailsUseCase();

    productDetailsViewModel = ProductDetailsViewModel(productDetailsUseCase);
  });

  // ==================== GetProductDetails ====================

  group('GetProductDetails', () {
    test('should load product details successfully', () async {
      // Arrange
      const productId = '40000000-0000-0000-0000-000000000009';

      const product = ProductDetailsEntity(
        id: productId,
        name: 'Red Rose',
        description: 'Beautiful red rose',
        imageUrls: ['https://example.com/rose.jpg'],
        includedItems: [],
        price: 500.0,
        discountedPrice: 450.0,
        discountPercent: 10.0,
        requiresStoreSelection: false,
        inStock: true,
        availableQuantity: 10,
      );

      when(productDetailsUseCase.call(productId: productId)).thenAnswer(
        (_) async => const SuccessResponse<ProductDetailsEntity>(product),
      );

      // Act
      await productDetailsViewModel.onEvent(
        const GetProductDetailsEvent(productId: productId),
      );

      // Assert
      expect(productDetailsViewModel.state.productDetailsState.data, product);

      expect(
        productDetailsViewModel.state.productDetailsState.isLoading,
        false,
      );

      expect(
        productDetailsViewModel.state.productDetailsState.errorMessage,
        '',
      );

      verify(productDetailsUseCase.call(productId: productId)).called(1);
    });

    test('should show error when getting product details fails', () async {
      // Arrange
      const productId = '40000000-0000-0000-0000-000000000009';

      const errorMessage = 'Failed to get product details';

      when(productDetailsUseCase.call(productId: productId)).thenAnswer(
        (_) async => ErrorResponse<ProductDetailsEntity>(
          appError: BadResponseError(errorMessage),
        ),
      );

      // Act
      await productDetailsViewModel.onEvent(
        const GetProductDetailsEvent(productId: productId),
      );

      // Assert
      expect(
        productDetailsViewModel.state.productDetailsState.isLoading,
        false,
      );

      expect(
        productDetailsViewModel.state.productDetailsState.errorMessage,
        errorMessage,
      );

      expect(productDetailsViewModel.state.productDetailsState.data, isNull);

      verify(productDetailsUseCase.call(productId: productId)).called(1);
    });
  });
}
