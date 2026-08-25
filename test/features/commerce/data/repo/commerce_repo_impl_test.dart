import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';

import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/categories_response.dart';
import 'package:flower_app/features/commerce/data/models/category_model.dart';
import 'package:flower_app/features/commerce/data/models/included_item_model.dart';
import 'package:flower_app/features/commerce/data/models/product_dto.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:flower_app/features/commerce/data/models/product_details_model.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';
import 'package:flower_app/features/commerce/data/repo/commerce_repo_impl.dart';

import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/included_item_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'commerce_repo_impl_test.mocks.dart';

@GenerateMocks([CommerceRemoteDataSource])
void main() {
  late MockCommerceRemoteDataSource commerceRemoteDataSource;
  late CommerceRepoImpl commerceRepoImpl;

  setUp(() {
    commerceRemoteDataSource = MockCommerceRemoteDataSource();

    commerceRepoImpl = CommerceRepoImpl(commerceRemoteDataSource, SafeCall());
  });

  // ==================== getAllCategories ====================

  group('getAllCategories', () {
    test(
      'should return categories as entities when api call succeeds',
      () async {
        // Arrange
        final response = CategoriesResponse(
          data: [CategoryModel(id: '1', name: 'Flowers')],
          statusCode: 200,
          success: true,
          message: 'Success',
          messageLocalized: 'Success',
        );

        when(
          commerceRemoteDataSource.getAllCategories(),
        ).thenAnswer((_) async => response);

        // Act
        final result = await commerceRepoImpl.getAllCategories();

        // Assert
        expect(result, isA<SuccessResponse<List<CategoryEntity>>>());

        final successResponse = result as SuccessResponse<List<CategoryEntity>>;

        expect(successResponse.data, [
          const CategoryEntity(id: '1', name: 'Flowers'),
        ]);

        verify(commerceRemoteDataSource.getAllCategories()).called(1);
      },
    );

    test('should return error response when api call fails', () async {
      // Arrange
      when(
        commerceRemoteDataSource.getAllCategories(),
      ).thenThrow(Exception('API Error'));

      // Act
      final result = await commerceRepoImpl.getAllCategories();

      // Assert
      expect(result, isA<ErrorResponse<List<CategoryEntity>>>());

      verify(commerceRemoteDataSource.getAllCategories()).called(1);
    });
  });

  

  // ==================== getProductDetails ====================

  group('getProductDetails', () {
    test(
      'should return product details as entity when api call succeeds',
      () async {
        // Arrange
        const productId = '40000000-0000-0000-0000-000000000009';

        final response = ProductDetailsResponseModel(
          data: ProductDetailsModel(
            id: productId,
            name: 'Red Rose',
            description: 'Beautiful red rose',
            imageUrls: ['https://example.com/rose.jpg'],
            includedItems: [IncludedItemModel(name: 'Red Rose', quantity: 1)],
            price: 500.0,
            discountedPrice: 450.0,
            discountPercent: 10.0,
            requiresStoreSelection: false,
            inStock: true,
            availableQuantity: 10,
          ),
          statusCode: 200,
          success: true,
          message: 'Success',
          messageLocalized: 'Success',
        );

        when(
          commerceRemoteDataSource.getProductDetails(productId),
        ).thenAnswer((_) async => response);

        // Act
        final result = await commerceRepoImpl.getProductDetails(
          productId: productId,
        );

        // Assert
        expect(result, isA<SuccessResponse<ProductDetailsEntity>>());

        final successResponse = result as SuccessResponse<ProductDetailsEntity>;

        expect(
          successResponse.data,
          const ProductDetailsEntity(
            id: productId,
            name: 'Red Rose',
            description: 'Beautiful red rose',
            imageUrls: ['https://example.com/rose.jpg'],
            includedItems: [IncludedItemEntity(name: 'Red Rose', quantity: 1)],
            price: 500.0,
            discountedPrice: 450.0,
            discountPercent: 10.0,
            requiresStoreSelection: false,
            inStock: true,
            availableQuantity: 10,
          ),
        );

        verify(commerceRemoteDataSource.getProductDetails(productId)).called(1);
      },
    );

    test('should return error response when api call fails', () async {
      // Arrange
      const productId = '40000000-0000-0000-0000-000000000009';

      when(
        commerceRemoteDataSource.getProductDetails(productId),
      ).thenThrow(Exception('API Error'));

      // Act
      final result = await commerceRepoImpl.getProductDetails(
        productId: productId,
      );

      // Assert
      expect(result, isA<ErrorResponse<ProductDetailsEntity>>());

      verify(commerceRemoteDataSource.getProductDetails(productId)).called(1);
    });
  });
}
