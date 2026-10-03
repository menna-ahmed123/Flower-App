import 'package:flower_app/features/cart/data/models/cart_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_preview_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_request.dart';
import 'package:flower_app/features/cart/data/models/order_response.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses the address-cart payload into a cart', () {
    final cart = CartResponse.fromJson({
      'status': true,
      'code': 200,
      'message': 'Cart retrieved',
      'data': {
        'cartId': 'cart-1',
        'items': [
          {
            'itemId': 'item-1',
            'productId': 'product-1',
            'productName': 'Red Rose',
            'productImage': 'https://cdn.example/rose.jpg',
            'unitPrice': 75,
            'priceAtAdd': 75,
            'quantity': 2,
            'lineSubtotal': 150,
            'availableStock': 10,
            'isAvailable': true,
            'priceChanged': false,
            'stockChanged': false,
          },
        ],
        'totalQuantity': 2,
        'lineCount': 1,
        'subtotal': 150,
        'deliveryFee': null,
        'total': 150,
        'hasChanges': false,
      },
      'pagination': null,
      'errors': null,
    });

    final entity = cart.data!.toDomain();
    expect(entity.id, 'cart-1');
    expect(entity.items.single.id, 'item-1');
    expect(entity.items.single.productId, 'product-1');
    expect(entity.items.single.name, 'Red Rose');
    expect(entity.items.single.imageUrl, 'https://cdn.example/rose.jpg');
    expect(entity.items.single.price, 75);
    expect(entity.items.single.quantity, 2);
    expect(entity.items.single.stock, 10);
    expect(entity.items.single.outOfStock, isFalse);
    expect(entity.itemCount, 2);
    expect(entity.subtotal, 150);
    expect(entity.deliveryFee, 0);
    expect(entity.total, 150);
    expect(entity.hasChanges, isFalse);
  });

  test('parses cart change flags from the address-cart payload', () {
    final cart = CartResponse.fromJson({
      'status': true,
      'code': 200,
      'data': {
        'cartId': 'cart-1',
        'items': [
          {
            'itemId': 'item-1',
            'productId': 'product-1',
            'productName': 'Classic Red Roses',
            'unitPrice': 499,
            'quantity': 3,
            'availableStock': 4,
            'isAvailable': false,
            'priceChanged': true,
            'stockChanged': true,
          },
        ],
        'subtotal': 1497,
        'deliveryFee': null,
        'total': 1497,
        'hasChanges': true,
      },
    }).data!.toDomain();

    expect(cart.hasChanges, isTrue);
    expect(cart.pricingUnavailable, isFalse);
    expect(cart.deliveryFee, 0);
    expect(cart.items.single.priceChanged, isTrue);
    expect(cart.items.single.outOfStock, isTrue);
    expect(cart.items.single.stock, 4);
  });

  test('empty cart items stay empty', () {
    final cart = CartDataModel.fromJson({
      'cartId': 'cart-1',
      'items': [],
      'totalQuantity': 0,
      'lineCount': 0,
      'subtotal': 0,
      'deliveryFee': null,
      'total': 0,
      'hasChanges': false,
    }).toDomain();

    expect(cart.items, isEmpty);
    expect(cart.itemCount, 0);
    expect(cart.total, 0);
  });

  test(
    'add acknowledgement and cart writes match the address-cart contract',
    () {
      final added = AddCartItemResponse.fromJson({
        'status': false,
        'code': 401,
        'message': 'Authentication required',
        'data': null,
      });
      expect(added.status, isFalse);
      expect(added.message, 'Authentication required');
      expect(const AddCartItemRequest(productId: 'p1', quantity: 2).toJson(), {
        'productId': 'p1',
        'quantity': 2,
      });
      expect(const UpdateCartItemRequest(quantity: 4).toJson(), {
        'quantity': 4,
      });
    },
  );

  test('checkout details map the orders contract', () {
    final details = CheckoutDetailsResponse.fromJson({
      'status': true,
      'code': 200,
      'message': 'Success',
      'data': {
        'cartId': 'e8ba4d5a-650d-4887-bb7d-e7898b021bcd',
        'addressId': '3e026c74-157b-44d3-bfa8-6f5a9a6addbb',
        'isServiceable': false,
        'subtotal': 517.90,
        'deliveryFee': 0,
        'total': 517.90,
        'estimatedDeliveryAt': null,
        'paymentMethods': [
          {'method': 'COD', 'gateways': null},
          {
            'method': 'Card',
            'gateways': ['Stripe'],
          },
        ],
        'isGift': false,
        'giftRecipientName': null,
        'giftRecipientPhone': null,
      },
      'pagination': null,
      'errors': null,
    }).data!.toDomain();

    expect(details.id, 'e8ba4d5a-650d-4887-bb7d-e7898b021bcd');
    expect(details.isServiceable, isFalse);
    expect(details.subtotal, 517.90);
    expect(details.deliveryFee, 0);
    expect(details.total, 517.90);
    expect(details.estimatedDeliveryAt, isNull);
    expect(details.paymentMethods, const [
      PaymentMethodEntity(name: 'Cash on Delivery', apiMethod: 'cod'),
      PaymentMethodEntity(
        name: 'Credit Card',
        apiMethod: 'Card',
        gateway: 'Stripe',
      ),
    ]);
  });

  test('checkout details keep a null delivery fee at zero', () {
    final details = CheckoutDetailsDataModel.fromJson({
      'cartId': 'cart-1',
      'subtotal': 40,
      'deliveryFee': null,
      'total': 40,
    }).toDomain();
    expect(details.deliveryFee, 0);
    expect(details.total, 40);
  });

  test('empty delivery estimate does not invent totals', () {
    expect(EstimateDeliveryResponse.parse('').toDomain().hasData, isFalse);
    expect(
      EstimateDeliveryResponse.parse({
        'status': true,
        'code': 200,
        'message': 'Success',
        'data': null,
      }).toDomain().hasData,
      isFalse,
    );
  });

  test('delivery estimate maps only fields the response includes', () {
    final estimate = EstimateDeliveryResponse.parse({
      'status': true,
      'data': {'deliveryFee': 25, 'total': 125, 'isServiceable': true},
    }).toDomain();
    expect(estimate.hasData, isTrue);
    expect(estimate.deliveryFee, 25);
    expect(estimate.total, 125);
    expect(estimate.subtotal, isNull);
    expect(estimate.isServiceable, isTrue);
    expect(estimate.includesDeliveryAt, isFalse);
  });

  test('COD place order maps the documented response', () {
    final order = OrderResponse.fromJson({
      'status': true,
      'code': 200,
      'message': 'Order placed successfully.',
      'data': {
        'orderId': 'c6397e92-123b-4659-8ed5-bde09472f787',
        'orderNumber': 'ORD-20260915-09CB27',
        'status': 'PLACED',
        'paymentStatus': 'PENDING',
        'paymentMethod': 'COD',
        'subtotal': 33.98,
        'deliveryFee': 25.0,
        'total': 58.98,
      },
    }).data!.toDomain();
    expect(order.orderId, 'c6397e92-123b-4659-8ed5-bde09472f787');
    expect(order.status, 'PLACED');
    expect(order.paymentStatus, 'PENDING');
    expect(order.paymentMethod, 'COD');
    expect(order.total, 58.98);
  });

  test('place order body matches COD and card contracts', () {
    expect(
      const PlaceOrderRequest(
        cartId: 'cart-1',
        addressId: 'address-1',
        isGift: false,
        giftRecipient: null,
        paymentMethod: 'cod',
        paymentGateway: null,
      ).toJson(),
      {
        'cartId': 'cart-1',
        'addressId': 'address-1',
        'isGift': false,
        'giftRecipient': null,
        'paymentMethod': 'cod',
        'paymentGateway': null,
      },
    );
    expect(
      const PlaceOrderRequest(
        cartId: 'cart-1',
        addressId: 'address-1',
        isGift: true,
        giftRecipient: GiftRecipientRequest(
          recipientName: 'Nada Ahmed',
          recipientPhone: '01098887966',
        ),
        paymentMethod: 'Card',
        paymentGateway: 'Stripe',
      ).toJson(),
      {
        'cartId': 'cart-1',
        'addressId': 'address-1',
        'isGift': true,
        'giftRecipient': {
          'recipientName': 'Nada Ahmed',
          'recipientPhone': '01098887966',
        },
        'paymentMethod': 'Card',
        'paymentGateway': 'Stripe',
      },
    );
  });

  test('payment checkout uses the payment service envelope', () {
    expect(
      const PaymentCheckoutRequest(
        orderId: 'order-1',
        amountTotal: 600,
        currency: 'USD',
      ).toJson(),
      {'orderId': 'order-1', 'amountTotal': 600, 'currency': 'USD'},
    );
    final payment = PaymentCheckoutResponse.fromJson({
      'value': {
        'checkoutUrl': 'https://checkout.stripe.com/c/pay/cs_test',
        'stripeSessionId': 'cs_test',
        'paymentAttemptId': 'attempt-1',
      },
      'isSuccess': true,
      'isFailure': false,
      'error': {'code': '', 'message': ''},
    });
    expect(payment.isSuccess, isTrue);
    expect(payment.value?.checkoutUrl, contains('checkout.stripe.com'));
    expect(payment.value?.stripeSessionId, 'cs_test');
    expect(payment.value?.paymentAttemptId, 'attempt-1');
  });
}
