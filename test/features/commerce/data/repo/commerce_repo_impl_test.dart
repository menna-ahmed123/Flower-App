import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';

import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/categories_response.dart';
import 'package:flower_app/features/commerce/data/models/category_model.dart';
import 'package:flower_app/features/commerce/data/models/product_dto.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:flower_app/features/commerce/data/repo/commerce_repo_impl.dart';

import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
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

  // ==================== getProductsByCategory ====================

  group('getProductsByCategory', () {
    test('should return products as entities when api call succeeds', () async {
      // Arrange
      const categoryId = '1';

      final response = ProductsResponse(
        data: ProductsDataDto(
          page: 1,
          pageSize: 10,
          totalCount: 1,
          items: [
            ProductDto(
              id: 'p1',
              name: 'Red Rose',
              imageUrl: 'https://example.com/rose.jpg',
              price: 100,
              discountedPrice: 80,
              discountPercent: 20,
              inStock: true,
            ),
          ],
        ),
        statusCode: 200,
        success: true,
        message: 'Success',
        messageLocalized: 'Success',
      );

      when(
        commerceRemoteDataSource.getProductsByCategory(categoryId),
      ).thenAnswer((_) async => response);

      // Act
      final result = await commerceRepoImpl.getProductsByCategory(categoryId);

      // Assert
      expect(result, isA<SuccessResponse<List<ProductEntity>>>());

      final successResponse = result as SuccessResponse<List<ProductEntity>>;

      expect(successResponse.data, [
        const ProductEntity(
          id: 'p1',
          name: 'Red Rose',
          imageUrl: 'https://example.com/rose.jpg',
          price: 100,
          discountedPrice: 80,
          discountPercent: 20,
          inStock: true,
        ),
      ]);

      verify(
        commerceRemoteDataSource.getProductsByCategory(categoryId),
      ).called(1);
    });

    test('should return error response when api call fails', () async {
      // Arrange
      const categoryId = '1';

      when(
        commerceRemoteDataSource.getProductsByCategory(categoryId),
      ).thenThrow(Exception('API Error'));

      // Act
      final result = await commerceRepoImpl.getProductsByCategory(categoryId);

      // Assert
      expect(result, isA<ErrorResponse<List<ProductEntity>>>());

      verify(
        commerceRemoteDataSource.getProductsByCategory(categoryId),
      ).called(1);
    });
  });
}
