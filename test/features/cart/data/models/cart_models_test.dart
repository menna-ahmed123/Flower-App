import 'package:flower_app/core/constants/api_query_params.dart';
import 'package:flower_app/features/cart/data/models/cart_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_preview_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_request.dart';
import 'package:flower_app/features/cart/data/models/order_response.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses Team 1 cart lines into items', () {
    final cart = CartResponse.fromJson({
      'success': true,
      'statusCode': 200,
      'data': {
        'id': 'cart-1',
        'lines': [
          {
            'id': 'item-1',
            'productId': 'product-1',
            'productName': 'Red Rose',
            'unitPrice': 100,
            'quantity': 2,
          },
        ],
        'itemCount': 2,
        'subtotal': 200,
      },
    });

    final entity = cart.data!.toDomain();
    expect(entity.items, hasLength(1));
    expect(entity.items.first.id, 'item-1');
    expect(entity.items.first.productId, 'product-1');
    expect(entity.items.first.name, 'Red Rose');
    expect(entity.items.first.price, 100);
    expect(entity.itemCount, 2);
  });

  test('parses Team 1 cart change flags', () {
    final cart = CartResponse.fromJson({
      'success': true,
      'statusCode': 200,
      'data': {
        'lines': [
          {
            'id': 'item-1',
            'productId': 'product-1',
            'name': 'Classic Red Roses',
            'unitPrice': 499,
            'quantity': 3,
            'availableQuantity': 4,
            'priceChanged': true,
            'outOfStock': false,
            'inStock': true,
          },
        ],
        'subtotal': 1497,
        'deliveryFee': null,
        'total': 1497,
        'isEmpty': false,
        'hasChanges': true,
        'pricingUnavailable': false,
      },
    }).data!.toDomain();

    expect(cart.hasChanges, isTrue);
    expect(cart.pricingUnavailable, isFalse);
    expect(cart.deliveryFee, 0);
    expect(cart.items.single.priceChanged, isTrue);
    expect(cart.items.single.outOfStock, isFalse);
    expect(cart.items.single.stock, 4);
  });

  test('add and update bodies include storeId', () {
    expect(const AddCartItemRequest(productId: 'p1', quantity: 2).toJson(), {
      'productId': 'p1',
      'quantity': 2,
      'storeId': ApiQueryParams.defaultStoreId,
    });
    expect(const UpdateCartItemRequest(quantity: 4).toJson(), {
      'quantity': 4,
      'storeId': ApiQueryParams.defaultStoreId,
    });
  });

  test('preview mapping uses API totals and deliveryAddress', () {
    final preview = CheckoutPreviewDataModel.fromJson({
      'items': [
        {
          'id': 'item-1',
          'productId': 'product-1',
          'name': 'Red Rose',
          'price': 50,
          'quantity': 2,
        },
      ],
      'subtotal': 80,
      'deliveryFee': 20,
      'discount': 5,
      'total': 95,
      'deliveryAddress': {
        'addressId': 'addr-1',
        'addressLine': '12 Nile',
        'city': 'Cairo',
      },
    }).toDomain();

    expect(preview.subtotal, 80);
    expect(preview.deliveryFee, 20);
    expect(preview.discount, 5);
    expect(preview.total, 95);
    expect(preview.deliveryAddress?.id, 'addr-1');
    expect(preview.deliveryAddress?.address, '12 Nile');
  });

  test('preview items map unitPrice when line id is absent', () {
    final preview = CheckoutPreviewDataModel.fromJson({
      'items': [
        {
          'productId': 'product-1',
          'name': 'Classic Red Roses',
          'unitPrice': 499,
          'quantity': 2,
          'lineSubtotal': 998,
        },
      ],
      'subtotal': 998,
      'deliveryFee': 50,
      'discount': 0,
      'total': 1048,
    }).toDomain();

    expect(preview.items.single.id, 'product-1');
    expect(preview.items.single.price, 499);
    expect(preview.items.single.quantity, 2);
    expect(preview.deliveryFee, 50);
    expect(preview.total, 1048);
  });

  test('order mapping reads payment session urls from the API', () {
    final order = OrderDataModel.fromJson({
      'orderId': 'order-1',
      'paymentUrl': 'https://pay.example/session',
      'success_url': 'https://app.example/success',
      'cancel_url': 'https://app.example/cancel',
    }).toDomain();

    expect(order.orderId, 'order-1');
    expect(order.sessionUrl, 'https://pay.example/session');
    expect(order.successUrl, 'https://app.example/success');
    expect(order.cancelUrl, 'https://app.example/cancel');
  });

  test('preview mapping reads payment methods from the API', () {
    final preview = CheckoutPreviewDataModel.fromJson({
      'paymentMethods': [
        {'name': 'Cash on Delivery', 'id': 1},
        {'label': 'Visa', 'paymentMethod': 2},
      ],
      'total': 1600,
    }).toDomain();
    expect(preview.paymentMethods, [
      const PaymentMethodEntity(name: 'Cash on Delivery', value: 1),
      const PaymentMethodEntity(name: 'Visa', value: 2),
    ]);
  });

  test('preview mapping does not calculate missing totals', () {
    final json = {
      'items': [
        {'id': 'item-1', 'productId': 'product-1', 'price': 50, 'quantity': 2},
      ],
    };
    expect(CheckoutPreviewDataModel.fromJson(json).toDomain().total, 0);
    expect(CartDataModel.fromJson(json).toDomain().total, 100);
  });

  test('checkout request omits unused address and gift fields', () {
    expect(
      const CheckoutRequest(paymentMethod: 1, expectedTotal: 1600).toJson(),
      {'paymentMethod': 1, 'expectedTotal': 1600},
    );
    expect(const CheckoutRequest(addressId: 'address-1').toJson(), {
      'addressId': 'address-1',
    });
  });
}
