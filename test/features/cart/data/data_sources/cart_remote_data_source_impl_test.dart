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
  provideDummy<CartResponse>(_cartResponse);
  _getCartTests();
  _addCartItemTests();
  _updateCartItemTests();
  _removeCartItemTests();
  _placeOrderTests();
  _processPaymentTests();
}

const _cartResponse = CartResponse(
  data: CartDataModel(id: 'cart-1', items: [], itemsCount: 0),
  statusCode: 200,
  success: true,
  message: 'Success',
);

class CartSourceCase {
  late MockCartApiClient apiClient;
  late CartRemoteDataSourceImpl dataSource;

  void setUp() {
    apiClient = MockCartApiClient();
    dataSource = CartRemoteDataSourceImpl(apiClient);
  }
}

void _getCartTests() {
  group('getCart', () {
    final c = CartSourceCase();
    setUp(c.setUp);
    test('forwards the default store id and returns the api response', () {
      return _getCartForwards(c);
    });
    test('rethrows when the api call fails', () => _getCartRethrows(c));
  });
}

Future<void> _getCartForwards(CartSourceCase c) async {
  when(c.apiClient.getCart(ApiQueryParams.defaultStoreId)).thenAnswer((_) async {
    return _cartResponse;
  });
  final result = await c.dataSource.getCart();
  expect(result, _cartResponse);
  verify(c.apiClient.getCart(ApiQueryParams.defaultStoreId)).called(1);
}

void _getCartRethrows(CartSourceCase c) {
  when(c.apiClient.getCart(ApiQueryParams.defaultStoreId)).thenThrow(
    Exception('API Error'),
  );
  expect(c.dataSource.getCart, throwsException);
}

void _addCartItemTests() {
  group('addCartItem', () {
    final c = CartSourceCase();
    setUp(c.setUp);
    test('forwards the request and returns the api response', () {
      return _addCartItemForwards(c);
    });
    test('rethrows when the api call fails', () => _addCartItemRethrows(c));
  });
}

Future<void> _addCartItemForwards(CartSourceCase c) async {
  const request = AddCartItemRequest(productId: 'product-1', quantity: 2);
  when(c.apiClient.addCartItem(request)).thenAnswer((_) async => _cartResponse);
  final result = await c.dataSource.addCartItem(request);
  expect(result, _cartResponse);
  verify(c.apiClient.addCartItem(request)).called(1);
}

void _addCartItemRethrows(CartSourceCase c) {
  const request = AddCartItemRequest(productId: 'product-1', quantity: 2);
  when(c.apiClient.addCartItem(request)).thenThrow(Exception('API Error'));
  expect(() => c.dataSource.addCartItem(request), throwsException);
}

void _updateCartItemTests() {
  group('updateCartItem', () {
    final c = CartSourceCase();
    setUp(c.setUp);
    test('forwards the item id and request and returns the api response', () {
      return _updateCartItemForwards(c);
    });
    test('rethrows when the api call fails', () => _updateCartItemRethrows(c));
  });
}

Future<void> _updateCartItemForwards(CartSourceCase c) async {
  const itemId = 'item-1';
  const request = UpdateCartItemRequest(quantity: 3);
  when(c.apiClient.updateCartItem(itemId, request)).thenAnswer((_) async {
    return _cartResponse;
  });
  final result = await c.dataSource.updateCartItem(itemId, request);
  expect(result, _cartResponse);
  verify(c.apiClient.updateCartItem(itemId, request)).called(1);
}

void _updateCartItemRethrows(CartSourceCase c) {
  const itemId = 'item-1';
  const request = UpdateCartItemRequest(quantity: 3);
  when(c.apiClient.updateCartItem(itemId, request)).thenThrow(
    Exception('API Error'),
  );
  expect(() => c.dataSource.updateCartItem(itemId, request), throwsException);
}

void _removeCartItemTests() {
  group('removeCartItem', () {
    final c = CartSourceCase();
    setUp(c.setUp);
    test('forwards the item id and default store id', () {
      return _removeCartItemForwards(c);
    });
    test('rethrows when the api call fails', () => _removeCartItemRethrows(c));
  });
}

Future<void> _removeCartItemForwards(CartSourceCase c) async {
  const itemId = 'item-1';
  when(
    c.apiClient.removeCartItem(itemId, ApiQueryParams.defaultStoreId),
  ).thenAnswer((_) async {});
  await c.dataSource.removeCartItem(itemId);
  verify(
    c.apiClient.removeCartItem(itemId, ApiQueryParams.defaultStoreId),
  ).called(1);
}

void _removeCartItemRethrows(CartSourceCase c) {
  const itemId = 'item-1';
  when(
    c.apiClient.removeCartItem(itemId, ApiQueryParams.defaultStoreId),
  ).thenThrow(Exception('API Error'));
  expect(() => c.dataSource.removeCartItem(itemId), throwsException);
}

void _placeOrderTests() {
  group('placeOrder', () {
    final c = CartSourceCase();
    setUp(c.setUp);
    test('forwards the request', () => _placeOrderForwards(c));
  });
}

Future<void> _placeOrderForwards(CartSourceCase c) async {
  when(c.apiClient.placeOrder()).thenAnswer((_) async {});
  await c.dataSource.placeOrder();
  verify(c.apiClient.placeOrder()).called(1);
}

void _processPaymentTests() {
  group('processPayment', () {
    final c = CartSourceCase();
    setUp(c.setUp);
    test('forwards the request', () => _processPaymentForwards(c));
  });
}

Future<void> _processPaymentForwards(CartSourceCase c) async {
  when(c.apiClient.processPayment()).thenAnswer((_) async {});
  await c.dataSource.processPayment();
  verify(c.apiClient.processPayment()).called(1);
}
