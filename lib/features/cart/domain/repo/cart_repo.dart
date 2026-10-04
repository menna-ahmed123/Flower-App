import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';

abstract interface class CartRepo {
  Future<BaseResponse<CartEntity>> getCart();

  Future<BaseResponse<CartEntity>> addItem({
    required String productId,
    int quantity = 1,
  });

  Future<BaseResponse<CartEntity>> updateItem({
    required String itemId,
    required int quantity,
  });

  Future<BaseResponse<CartEntity>> removeItem({required String itemId});

  Future<BaseResponse<CartEntity>> checkoutDetails({required String cartId});

  Future<BaseResponse<DeliveryEstimateEntity>> estimateDelivery({
    required String addressId,
    required String cartId,
  });

  Future<BaseResponse<OrderEntity>> placeOrder({
    required String idempotencyKey,
    required String cartId,
    required String addressId,
    required bool isGift,
    String? recipientName,
    String? recipientPhone,
    required String paymentMethod,
    String? paymentGateway,
  });

  Future<BaseResponse<PaymentCheckoutEntity>> createPaymentCheckout({
    required String orderId,
    required double amountTotal,
    required String currency,
  });
}
