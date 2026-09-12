import 'package:flower_app/core/constants/api_query_params.dart';
import 'package:flower_app/features/cart/api/cart_api_client.dart';
import 'package:flower_app/features/cart/data/data_sources/cart_remote_data_source_impl.dart';
import 'package:flower_app/features/cart/data/models/cart_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([CartApiClient])
void main() {
  const response = CartResponse(
    data: CartDataModel(id: 'cart-1', items: [], itemsCount: 0),
    statusCode: 200,
    success: true,
    message: 'Success',
  );

  provideDummy<CartResponse>(response);

  late MockCartApiClient apiClient;
  late CartRemoteDataSourceImpl dataSource;

  setUp(() {
    apiClient = MockCartApiClient();
    dataSource = CartRemoteDataSourceImpl(apiClient);
  });

  group('getCart', () {
    test('forwards the default store id and returns the api response', () async {
      when(
        apiClient.getCart(ApiQueryParams.defaultStoreId),
      ).thenAnswer((_) async => response);

      final result = await dataSource.getCart();

      expect(result, response);
      verify(apiClient.getCart(ApiQueryParams.defaultStoreId)).called(1);
    });

    test('rethrows when the api call fails', () async {
      when(
        apiClient.getCart(ApiQueryParams.defaultStoreId),
      ).thenThrow(Exception('API Error'));

      expect(dataSource.getCart, throwsException);
    });
  });

  group('addCartItem', () {
    const request = AddCartItemRequest(productId: 'product-1', quantity: 2);

    test('forwards the request and returns the api response', () async {
      when(apiClient.addCartItem(request)).thenAnswer((_) async => response);

      final result = await dataSource.addCartItem(request);

      expect(result, response);
      verify(apiClient.addCartItem(request)).called(1);
    });

    test('rethrows when the api call fails', () async {
      when(apiClient.addCartItem(request)).thenThrow(Exception('API Error'));

      expect(() => dataSource.addCartItem(request), throwsException);
    });
  });

  group('updateCartItem', () {
    const itemId = 'item-1';
    const request = UpdateCartItemRequest(quantity: 3);

    test('forwards the item id and request and returns the api response', () async {
      when(
        apiClient.updateCartItem(itemId, request),
      ).thenAnswer((_) async => response);

      final result = await dataSource.updateCartItem(itemId, request);

      expect(result, response);
      verify(apiClient.updateCartItem(itemId, request)).called(1);
    });

    test('rethrows when the api call fails', () async {
      when(
        apiClient.updateCartItem(itemId, request),
      ).thenThrow(Exception('API Error'));

      expect(() => dataSource.updateCartItem(itemId, request), throwsException);
    });
  });

  group('removeCartItem', () {
    const itemId = 'item-1';

    test('forwards the item id and default store id', () async {
      when(
        apiClient.removeCartItem(itemId, ApiQueryParams.defaultStoreId),
      ).thenAnswer((_) async {});

      await dataSource.removeCartItem(itemId);

      verify(
        apiClient.removeCartItem(itemId, ApiQueryParams.defaultStoreId),
      ).called(1);
    });

    test('rethrows when the api call fails', () async {
      when(
        apiClient.removeCartItem(itemId, ApiQueryParams.defaultStoreId),
      ).thenThrow(Exception('API Error'));

      expect(() => dataSource.removeCartItem(itemId), throwsException);
    });
  });

  group('placeOrder', () {
    test('forwards the request', () async {
      when(apiClient.placeOrder()).thenAnswer((_) async {});

      await dataSource.placeOrder();

      verify(apiClient.placeOrder()).called(1);
    });
  });

  group('processPayment', () {
    test('forwards the request', () async {
      when(apiClient.processPayment()).thenAnswer((_) async {});

      await dataSource.processPayment();

      verify(apiClient.processPayment()).called(1);
    });
  });
}
