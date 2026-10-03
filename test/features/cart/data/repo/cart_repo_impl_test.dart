import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/cart/data/data_sources/cart_remote_data_source.dart';
import 'package:flower_app/features/cart/data/models/cart_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_preview_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_request.dart';
import 'package:flower_app/features/cart/data/models/order_response.dart';
import 'package:flower_app/features/cart/data/repo/cart_repo_impl.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _CartApiDouble api;
  late CartRepoImpl repo;

  setUp(() {
    api = _CartApiDouble();
    repo = CartRepoImpl(api, SafeCall());
  });

  test('get cart maps the address-cart payload', () async {
    final result = await repo.getCart();
    final cart = (result as SuccessResponse<CartEntity>).data;
    expect(cart.id, 'cart-1');
    expect(cart.items.single.productId, 'product-1');
    expect(cart.itemCount, 2);
    expect(cart.total, 150);
  });

  test('get cart returns the backend failure message', () async {
    api.cart = const CartResponse(
      status: false,
      code: 401,
      message: 'Authentication required',
    );
    final result = await repo.getCart();
    expect(result, isA<ErrorResponse<CartEntity>>());
    expect(
      (result as ErrorResponse<CartEntity>).errorMessage,
      'Authentication required',
    );
  });

  test('add item sends product and quantity, then reloads the cart', () async {
    final result = await repo.addItem(productId: 'product-1', quantity: 2);
    expect(api.addRequest?.toJson(), {'productId': 'product-1', 'quantity': 2});
    expect(api.getCalls, 1);
    expect((result as SuccessResponse<CartEntity>).data.items, isNotEmpty);
  });

  test(
    'add item does not reload the cart when the write is rejected',
    () async {
      api.add = const AddCartItemResponse(
        status: false,
        code: 400,
        message: 'Invalid request',
      );
      final result = await repo.addItem(productId: 'product-1');
      expect(api.getCalls, 0);
      expect(
        (result as ErrorResponse<CartEntity>).errorMessage,
        'Invalid request',
      );
    },
  );

  test('update quantity returns the cart from the response', () async {
    final result = await repo.updateItem(itemId: 'item-1', quantity: 3);
    expect(api.updatedItemId, 'item-1');
    expect(api.updateRequest?.quantity, 3);
    expect((result as SuccessResponse<CartEntity>).data.itemCount, 2);
  });

  test('remove item returns the remaining cart', () async {
    final result = await repo.removeItem(itemId: 'item-1');
    expect(api.removedItemId, 'item-1');
    expect((result as SuccessResponse<CartEntity>).data.id, 'cart-1');
  });

  test('network failures stay failures', () async {
    api.getError = Exception('network');
    final result = await repo.getCart();
    expect(result, isA<ErrorResponse<CartEntity>>());
  });

  test('checkout details sends cartId and maps payment methods', () async {
    api.details = CheckoutDetailsResponse.fromJson(_detailsJson);
    final result = await repo.checkoutDetails(cartId: 'cart-1');
    expect(api.detailsCartId, 'cart-1');
    final cart = (result as SuccessResponse<CartEntity>).data;
    expect(cart.isServiceable, isFalse);
    expect(cart.total, 517.90);
    expect(cart.paymentMethods.map((method) => method.apiMethod), [
      'cod',
      'Card',
    ]);
    expect(cart.paymentMethods.last.gateway, 'Stripe');
  });

  test('estimate delivery sends AddressId and CartId', () async {
    api.estimate = EstimateDeliveryResponse.parse({
      'status': true,
      'data': {'deliveryFee': 25, 'total': 125},
    });
    final result = await repo.estimateDelivery(
      addressId: 'address-1',
      cartId: 'cart-1',
    );
    expect(api.estimateAddressId, 'address-1');
    expect(api.estimateCartId, 'cart-1');
    final estimate = (result as SuccessResponse).data;
    expect(estimate.deliveryFee, 25);
    expect(estimate.total, 125);
    expect(estimate.subtotal, isNull);
  });

  test('COD place order sends the documented body and header key', () async {
    final result = await repo.placeOrder(
      idempotencyKey: 'idem-1',
      cartId: 'cart-1',
      addressId: 'address-1',
      isGift: false,
      paymentMethod: 'cod',
      paymentGateway: null,
    );
    expect(api.idempotencyKey, 'idem-1');
    expect(api.placeRequest?.toJson(), {
      'cartId': 'cart-1',
      'addressId': 'address-1',
      'isGift': false,
      'giftRecipient': null,
      'paymentMethod': 'cod',
      'paymentGateway': null,
    });
    final order = (result as SuccessResponse<OrderEntity>).data;
    expect(order.status, 'PLACED');
    expect(order.paymentStatus, 'PENDING');
  });

  test('card payment checkout is separate from place order', () async {
    final result = await repo.createPaymentCheckout(
      orderId: 'order-1',
      amountTotal: 600,
      currency: 'USD',
    );
    expect(api.paymentRequest?.toJson(), {
      'orderId': 'order-1',
      'amountTotal': 600,
      'currency': 'USD',
    });
    final payment = (result as SuccessResponse<PaymentCheckoutEntity>).data;
    expect(payment.checkoutUrl, contains('checkout.stripe.com'));
    expect(payment.stripeSessionId, 'cs_test');
    expect(api.placeRequest, isNull);
  });

  test('failed payment checkout is not treated as paid', () async {
    api.payment = const PaymentCheckoutResponse(
      isSuccess: false,
      isFailure: true,
      error: PaymentCheckoutError(code: 'failed', message: 'Card declined'),
    );
    final result = await repo.createPaymentCheckout(
      orderId: 'order-1',
      amountTotal: 600,
      currency: 'USD',
    );
    expect(result, isA<ErrorResponse<PaymentCheckoutEntity>>());
    expect(
      (result as ErrorResponse<PaymentCheckoutEntity>).errorMessage,
      'Card declined',
    );
  });
}

class _CartApiDouble implements CartRemoteDataSource {
  CartResponse cart = CartResponse.fromJson(_cartJson);
  AddCartItemResponse add = AddCartItemResponse.fromJson(_addJson);
  int getCalls = 0;
  AddCartItemRequest? addRequest;
  String? updatedItemId;
  UpdateCartItemRequest? updateRequest;
  String? removedItemId;
  Object? getError;
  CheckoutDetailsResponse details = const CheckoutDetailsResponse();
  EstimateDeliveryResponse estimate = const EstimateDeliveryResponse();
  OrderResponse order = OrderResponse.fromJson(const {
    'status': true,
    'code': 200,
    'message': 'Order placed successfully.',
    'data': {
      'orderId': 'order-1',
      'status': 'PLACED',
      'paymentStatus': 'PENDING',
      'paymentMethod': 'COD',
      'total': 58.98,
    },
  });
  PaymentCheckoutResponse payment = const PaymentCheckoutResponse(
    isSuccess: true,
    isFailure: false,
    value: PaymentCheckoutValue(
      checkoutUrl: 'https://checkout.stripe.com/c/pay/cs_test',
      stripeSessionId: 'cs_test',
      paymentAttemptId: 'attempt-1',
    ),
  );
  String? detailsCartId;
  String? estimateAddressId;
  String? estimateCartId;
  String? idempotencyKey;
  PlaceOrderRequest? placeRequest;
  PaymentCheckoutRequest? paymentRequest;

  @override
  Future<CartResponse> getCart() async {
    getCalls++;
    final error = getError;
    if (error != null) throw error;
    return cart;
  }

  @override
  Future<AddCartItemResponse> addCartItem(AddCartItemRequest request) async {
    addRequest = request;
    return add;
  }

  @override
  Future<CartResponse> updateCartItem(
    String itemId,
    UpdateCartItemRequest request,
  ) async {
    updatedItemId = itemId;
    updateRequest = request;
    return cart;
  }

  @override
  Future<CartResponse> removeCartItem(String itemId) async {
    removedItemId = itemId;
    return cart;
  }

  @override
  Future<CheckoutDetailsResponse> checkoutDetails(String cartId) async {
    detailsCartId = cartId;
    return details;
  }

  @override
  Future<EstimateDeliveryResponse> estimateDelivery({
    required String addressId,
    required String cartId,
  }) async {
    estimateAddressId = addressId;
    estimateCartId = cartId;
    return estimate;
  }

  @override
  Future<OrderResponse> placeOrder(
    String idempotencyKey,
    PlaceOrderRequest request,
  ) async {
    this.idempotencyKey = idempotencyKey;
    placeRequest = request;
    return order;
  }

  @override
  Future<PaymentCheckoutResponse> createPaymentCheckout(
    PaymentCheckoutRequest request,
  ) async {
    paymentRequest = request;
    return payment;
  }
}

const _cartJson = {
  'status': true,
  'code': 200,
  'message': 'Cart retrieved',
  'data': {
    'cartId': 'cart-1',
    'items': [
      {
        'itemId': 'item-1',
        'productId': 'product-1',
        'productName': 'Rose',
        'unitPrice': 75,
        'quantity': 2,
        'lineSubtotal': 150,
        'availableStock': 10,
        'isAvailable': true,
      },
    ],
    'totalQuantity': 2,
    'lineCount': 1,
    'subtotal': 150,
    'deliveryFee': null,
    'total': 150,
    'hasChanges': false,
  },
};

const _detailsJson = {
  'status': true,
  'code': 200,
  'message': 'Success',
  'data': {
    'cartId': 'cart-1',
    'isServiceable': false,
    'subtotal': 517.90,
    'deliveryFee': 0,
    'total': 517.90,
    'paymentMethods': [
      {'method': 'COD', 'gateways': null},
      {
        'method': 'Card',
        'gateways': ['Stripe'],
      },
    ],
  },
};

const _addJson = {
  'status': true,
  'code': 200,
  'message': 'Item added to cart',
  'data': {
    'cartId': 'cart-1',
    'itemId': 'item-1',
    'productId': 'product-1',
    'quantity': 2,
    'priceAtAdd': 75,
  },
};
