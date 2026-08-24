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
      data: [CategoryModel(id: '1', name: 'Flowers')],
      statusCode: 200,
      success: true,
      message: 'Success',
      messageLocalized: 'Success',
    ),
  );

  provideDummy<ProductsResponse>(
    ProductsResponse(
      data: ProductsDataDto(page: 1, pageSize: 10, totalCount: 0, items: []),
      statusCode: 200,
      success: true,
      message: 'Success',
      messageLocalized: 'Success',
    ),
  );

  provideDummy<ProductDetailsResponseModel>(
    ProductDetailsResponseModel(
      data: ProductDetailsModel(
        id: '40000000-0000-0000-0000-000000000009',
        name: 'Red Roses',
        description: 'Beautiful red roses',
        imageUrls: ['https://example.com/rose.jpg'],
        includedItems: [],
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
    ),
  );

  // Arrange
  late MockCommerceApiClient commerceApiClient;
  late CommerceRemoteDataSourceImpl datasourceImpl;

  setUpAll(() {
    commerceApiClient = MockCommerceApiClient();
    datasourceImpl = CommerceRemoteDataSourceImpl(commerceApiClient);
  });

  group('getAllCategories', () {
    test('should return categories response when api call succeeds', () async {
      // Arrange
      final response = CategoriesResponse(
        data: [CategoryModel(id: '1', name: 'Flowers')],
        statusCode: 200,
        success: true,
        message: 'Success',
        messageLocalized: 'Success',
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
      final call = datasourceImpl.getAllCategories;

      // Assert
      expect(call, throwsException);
    });
  });

  group('getProductsByCategory', () {
    test('should return products response when api call succeeds', () async {
      // Arrange
      const categoryId = '1';

      final response = ProductsResponse(
        data: ProductsDataDto(page: 1, pageSize: 10, totalCount: 0, items: []),
        statusCode: 200,
        success: true,
        message: 'Success',
        messageLocalized: 'Success',
      );

      when(
        commerceApiClient.getProductsByCategory(categoryId),
      ).thenAnswer((_) async => response);

      // Act
      final result = await datasourceImpl.getProductsByCategory(categoryId);

      // Assert
      expect(result, response);

      verify(commerceApiClient.getProductsByCategory(categoryId)).called(1);
    });

    test('should throw an exception when api call fails', () async {
      // Arrange
      const categoryId = '1';

      when(
        commerceApiClient.getProductsByCategory(categoryId),
      ).thenThrow(Exception('API Error'));

      // Act
      Future<ProductsResponse> call() {
        return datasourceImpl.getProductsByCategory(categoryId);
      }

      // Assert
      expect(call, throwsException);
    });
  });

  group('getProductDetails', () {
    test(
      'should return product details response when api call succeeds',
      () async {
        // Arrange
        const productId = '40000000-0000-0000-0000-000000000009';

        final response = ProductDetailsResponseModel(
          data: ProductDetailsModel(
            id: productId,
            name: 'Red Roses',
            description: 'Beautiful red roses',
            imageUrls: ['https://example.com/rose.jpg'],
            includedItems: [],
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
