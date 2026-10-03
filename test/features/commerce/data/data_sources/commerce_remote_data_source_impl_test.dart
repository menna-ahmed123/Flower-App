import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source_impl.dart';
import 'package:flower_app/features/commerce/data/models/categories_response.dart';
import 'package:flower_app/features/commerce/data/models/category_model.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';
import 'package:flower_app/features/commerce/data/models/product_details_model.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flower_app/features/commerce/api/commerce_api_client.dart';

import 'commerce_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([CommerceApiClient])
void main() {
  provideDummy<CategoriesResponse>(
    CategoriesResponse(
      status: true,
      code: 200,
      message: 'Success',
      data: [CategoryModel(id: '1', name: 'Flowers')],
    ),
  );

  provideDummy<ProductsResponse>(
    const ProductsResponse(
      status: true,
      code: 200,
      message: 'Success',
      data: [],
    ),
  );

  provideDummy<ProductDetailsResponseModel>(
    ProductDetailsResponseModel(
      status: true,
      code: 200,
      message: 'Success',
      data: ProductDetailsModel(
        id: '40000000-0000-0000-0000-000000000009',
        name: 'Red Roses',
        description: 'Beautiful red roses',
        images: ['https://example.com/rose.jpg'],
        includes: ['Red roses: 15'],
        price: 500.0,
        discountedPrice: 450.0,
        discountPercent: 10.0,
        inStock: true,
        availableStock: 10,
      ),
    ),
  );

  late MockCommerceApiClient commerceApiClient;
  late CommerceRemoteDataSourceImpl datasourceImpl;

  setUp(() {
    commerceApiClient = MockCommerceApiClient();
    datasourceImpl = CommerceRemoteDataSourceImpl(commerceApiClient);
  });

  // ==================== getAllCategories ====================

  group('getAllCategories', () {
    test('should return categories response when api call succeeds', () async {
      // Arrange
      final response = CategoriesResponse(
        status: true,
        code: 200,
        message: 'Success',
        data: [CategoryModel(id: '1', name: 'Flowers')],
      );

      when(
        commerceApiClient.getAllCategories(),
      ).thenAnswer((_) async => response);

      // Act
      final result = await datasourceImpl.getAllCategories();

      // Assert
      expect(result, response);
      verify(commerceApiClient.getAllCategories()).called(1);
    });

    test('should throw an exception when api call fails', () async {
      // Arrange
      when(
        commerceApiClient.getAllCategories(),
      ).thenThrow(Exception('API Error'));

      // Act
      Future<CategoriesResponse> call() {
        return datasourceImpl.getAllCategories();
      }

      // Assert
      expect(call, throwsException);
    });
  });

  // ==================== getProducts by Category ====================

  group('getProducts', () {
    test(
      'should return products response when filtering by category',
      () async {
        // Arrange
        const categoryId = '1';

        const response = ProductsResponse(
          status: true,
          code: 200,
          message: 'Success',
          data: [],
        );

        when(
          commerceApiClient.getProducts(categoryId: categoryId),
        ).thenAnswer((_) async => response);

        // Act
        final result = await datasourceImpl.getProducts(categoryId: categoryId);

        // Assert
        expect(result, response);
        verify(commerceApiClient.getProducts(categoryId: categoryId)).called(1);
      },
    );

    test('should throw an exception when api call fails', () async {
      // Arrange
      const categoryId = '1';

      when(
        commerceApiClient.getProducts(categoryId: categoryId),
      ).thenThrow(Exception('API Error'));

      // Act
      Future<ProductsResponse> call() {
        return datasourceImpl.getProducts(categoryId: categoryId);
      }

      // Assert
      expect(call, throwsException);
    });
  });

  // ==================== getProductDetails ====================

  group('getProductDetails', () {
    test(
      'should return product details response when api call succeeds',
      () async {
        // Arrange
        const productId = '40000000-0000-0000-0000-000000000009';

        final response = ProductDetailsResponseModel(
          status: true,
          code: 200,
          message: 'Success',
          data: ProductDetailsModel(
            id: productId,
            name: 'Red Roses',
            description: 'Beautiful red roses',
            images: ['https://example.com/rose.jpg'],
            includes: ['Red roses: 15'],
            price: 500.0,
            discountedPrice: 450.0,
            discountPercent: 10.0,
            inStock: true,
            availableStock: 10,
          ),
        );

        when(
          commerceApiClient.getProductDetails(productId),
        ).thenAnswer((_) async => response);

        // Act
        final result = await datasourceImpl.getProductDetails(productId);

        // Assert
        expect(result, response);
        verify(commerceApiClient.getProductDetails(productId)).called(1);
      },
    );

    test('should throw an exception when api call fails', () async {
      // Arrange
      const productId = '40000000-0000-0000-0000-000000000009';

      when(
        commerceApiClient.getProductDetails(productId),
      ).thenThrow(Exception('API Error'));

      // Act
      Future<ProductDetailsResponseModel> call() {
        return datasourceImpl.getProductDetails(productId);
      }

      // Assert
      expect(call, throwsException);
    });
  });
}
