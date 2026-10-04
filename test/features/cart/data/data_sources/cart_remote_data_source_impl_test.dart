import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/api_query_params.dart';
import 'package:flower_app/features/cart/api/cart_api_client.dart';
import 'package:flower_app/features/cart/data/data_sources/cart_remote_data_source_impl.dart';
import 'package:flower_app/features/cart/data/models/cart_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_preview_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_request.dart';
import 'package:flower_app/features/cart/data/models/order_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/retrofit.dart';

import 'cart_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([CartApiClient])
void main() {
  provideDummy<CartResponse>(_cartResponse);
  provideDummy<AddCartItemResponse>(_addResponse);
  provideDummy<CheckoutDetailsResponse>(_detailsResponse);
  provideDummy<OrderResponse>(const OrderResponse(status: true, code: 200));
  provideDummy<PaymentCheckoutResponse>(const PaymentCheckoutResponse());
  provideDummy<HttpResponse<dynamic>>(_httpResponse);
  _getCartTests();
  _addCartItemTests();
  _updateCartItemTests();
  _removeCartItemTests();
  _checkoutDetailsTests();
  _estimateTests();
  _placeOrderTests();
  _paymentTests();
  _contractTests();
}

const _cartResponse = CartResponse(
  data: CartDataModel(cartId: 'cart-1', items: [], totalQuantity: 0),
  code: 200,
  status: true,
  message: 'Success',
);

const _addResponse = AddCartItemResponse(
  data: AddCartItemDataModel(
    cartId: 'cart-1',
    itemId: 'item-1',
    productId: 'product-1',
    quantity: 2,
    priceAtAdd: 75,
  ),
  code: 200,
  status: true,
  message: 'Item added to cart',
);

const _detailsResponse = CheckoutDetailsResponse(
  data: CheckoutDetailsDataModel(cartId: 'cart-1', total: 100),
  code: 200,
  status: true,
  message: 'Success',
);

final _httpResponse = HttpResponse<dynamic>(
  '{"status":true,"data":null}',
  Response<dynamic>(
    requestOptions: RequestOptions(),
    statusCode: 200,
    data: '{"status":true,"data":null}',
  ),
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
    test('returns the api response', () => _getCartForwards(c));
    test('rethrows when the api call fails', () => _getCartRethrows(c));
  });
}

Future<void> _getCartForwards(CartSourceCase c) async {
  when(c.apiClient.getCart()).thenAnswer((_) async => _cartResponse);
  final result = await c.dataSource.getCart();
  expect(result, _cartResponse);
  verify(c.apiClient.getCart()).called(1);
}

void _getCartRethrows(CartSourceCase c) {
  when(c.apiClient.getCart()).thenThrow(Exception('API Error'));
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
  when(c.apiClient.addCartItem(request)).thenAnswer((_) async => _addResponse);
  final result = await c.dataSource.addCartItem(request);
  expect(result, _addResponse);
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
  when(
    c.apiClient.updateCartItem(itemId, request),
  ).thenThrow(Exception('API Error'));
  expect(() => c.dataSource.updateCartItem(itemId, request), throwsException);
}

void _removeCartItemTests() {
  group('removeCartItem', () {
    final c = CartSourceCase();
    setUp(c.setUp);
    test('forwards the item id and returns the cart', () {
      return _removeCartItemForwards(c);
    });
    test('rethrows when the api call fails', () => _removeCartItemRethrows(c));
  });
}

Future<void> _removeCartItemForwards(CartSourceCase c) async {
  const itemId = 'item-1';
  when(c.apiClient.removeCartItem(itemId)).thenAnswer((_) async {
    return _cartResponse;
  });
  final result = await c.dataSource.removeCartItem(itemId);
  expect(result, _cartResponse);
  verify(c.apiClient.removeCartItem(itemId)).called(1);
}

void _removeCartItemRethrows(CartSourceCase c) {
  const itemId = 'item-1';
  when(c.apiClient.removeCartItem(itemId)).thenThrow(Exception('API Error'));
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
  const request = PlaceOrderRequest(
    cartId: 'cart-1',
    addressId: 'address-1',
    isGift: false,
    giftRecipient: null,
    paymentMethod: 'COD',
    paymentGateway: null,
  );
  when(c.apiClient.placeOrder('key', request)).thenAnswer((_) async {
    return const OrderResponse(status: true, code: 200);
  });
  final result = await c.dataSource.placeOrder('key', request);
  expect(result.status, isTrue);
  verify(c.apiClient.placeOrder('key', request)).called(1);
}

void _checkoutDetailsTests() {
  group('checkoutDetails', () {
    final c = CartSourceCase();
    setUp(c.setUp);
    test('forwards cartId', () => _checkoutDetailsForwards(c));
  });
}

Future<void> _checkoutDetailsForwards(CartSourceCase c) async {
  when(c.apiClient.checkoutDetails('cart-1')).thenAnswer((_) async {
    return _detailsResponse;
  });
  final result = await c.dataSource.checkoutDetails('cart-1');
  expect(result, _detailsResponse);
  verify(c.apiClient.checkoutDetails('cart-1')).called(1);
}

void _estimateTests() {
  group('estimateDelivery', () {
    final c = CartSourceCase();
    setUp(c.setUp);
    test('parses an empty estimate body', () => _estimateParses(c));
  });
}

Future<void> _estimateParses(CartSourceCase c) async {
  when(c.apiClient.estimateDelivery('address-1', 'cart-1')).thenAnswer((
    _,
  ) async {
    return _httpResponse;
  });
  final result = await c.dataSource.estimateDelivery(
    addressId: 'address-1',
    cartId: 'cart-1',
  );
  expect(result.data, isNull);
  verify(c.apiClient.estimateDelivery('address-1', 'cart-1')).called(1);
}

void _paymentTests() {
  group('createPaymentCheckout', () {
    final c = CartSourceCase();
    setUp(c.setUp);
    test('forwards the payment request', () => _paymentForwards(c));
  });
}

Future<void> _paymentForwards(CartSourceCase c) async {
  const request = PaymentCheckoutRequest(
    orderId: 'order-1',
    amountTotal: 600,
    currency: 'USD',
  );
  when(c.apiClient.createPaymentCheckout(request)).thenAnswer((_) async {
    return const PaymentCheckoutResponse(isSuccess: true, isFailure: false);
  });
  final result = await c.dataSource.createPaymentCheckout(request);
  expect(result.isSuccess, isTrue);
  verify(c.apiClient.createPaymentCheckout(request)).called(1);
}

void _contractTests() {
  group('checkout HTTP contract', () {
    test('details, estimate, place, and payment use the documented calls', () {
      return _assertsCheckoutContract();
    });
  });
}

Future<void> _assertsCheckoutContract() async {
  final capture = _CaptureAdapter();
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
  dio.interceptors.add(capture);
  final client = CartApiClient(dio);
  await client.getCart();
  _expectCall(capture, 'GET', ApiEndpoints.cart, const {});
  await client.addCartItem(
    const AddCartItemRequest(productId: 'product-1', quantity: 2),
  );
  _expectCall(capture, 'POST', ApiEndpoints.cartItems, const {});
  expect(capture.body, {'productId': 'product-1', 'quantity': 2});
  await client.updateCartItem(
    'item-1',
    const UpdateCartItemRequest(quantity: 3),
  );
  _expectCall(
    capture,
    'PATCH',
    '/api/address-cart/cart/items/item-1',
    const {},
  );
  expect(capture.body, {'quantity': 3});
  await client.removeCartItem('item-1');
  _expectCall(
    capture,
    'DELETE',
    '/api/address-cart/cart/items/item-1',
    const {},
  );
  await client.checkoutDetails('cart-1');
  _expectCall(capture, 'GET', ApiEndpoints.checkoutDetails, {
    ApiQueryParams.cartId: 'cart-1',
  });
  await client.estimateDelivery('address-1', 'cart-9');
  _expectCall(capture, 'GET', ApiEndpoints.estimateDelivery, {
    ApiQueryParams.estimateAddressId: 'address-1',
    ApiQueryParams.estimateCartId: 'cart-9',
  });
  await client.placeOrder('idem-1', _codRequest);
  _expectCall(capture, 'POST', ApiEndpoints.placeOrder, const {});
  expect(capture.headers[ApiQueryParams.idempotencyKey], 'idem-1');
  expect(capture.body, _codRequest.toJson());
  await client.createPaymentCheckout(_paymentRequest);
  _expectCall(capture, 'POST', ApiEndpoints.paymentCheckout, const {});
  expect(capture.body, _paymentRequest.toJson());
}

void _expectCall(
  _CaptureAdapter capture,
  String method,
  String path,
  Map<String, dynamic> query,
) {
  expect(capture.method, method);
  expect(capture.path, path);
  expect(capture.query, query);
}

const _codRequest = PlaceOrderRequest(
  cartId: 'cart-1',
  addressId: 'address-1',
  isGift: false,
  giftRecipient: null,
  paymentMethod: 'COD',
  paymentGateway: null,
);

const _paymentRequest = PaymentCheckoutRequest(
  orderId: 'order-1',
  amountTotal: 600,
  currency: 'USD',
);

class _CaptureAdapter extends Interceptor {
  String? method;
  String? path;
  Map<String, dynamic> query = const {};
  Map<String, dynamic> headers = const {};
  Object? body;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    method = options.method;
    path = options.path;
    query = options.queryParameters;
    headers = options.headers;
    body = options.data;
    handler.resolve(
      Response<dynamic>(
        requestOptions: options,
        statusCode: 200,
        data: const {'status': true, 'code': 200, 'data': null},
      ),
    );
  }
}
