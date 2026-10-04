import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo/cart_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class PreviewCheckoutUseCase {
  PreviewCheckoutUseCase(this.cartRepo);

  final CartRepo cartRepo;

  Future<BaseResponse<CartEntity>> getCart() => cartRepo.getCart();

  Future<BaseResponse<CartEntity>> checkoutDetails({required String cartId}) {
    return cartRepo.checkoutDetails(cartId: cartId);
  }

  Future<BaseResponse<DeliveryEstimateEntity>> estimateDelivery({
    required String addressId,
    required String cartId,
  }) {
    return cartRepo.estimateDelivery(addressId: addressId, cartId: cartId);
  }
}

@injectable
class PlaceOrderUseCase {
  PlaceOrderUseCase(this.cartRepo);

  final CartRepo cartRepo;

  Future<BaseResponse<OrderEntity>> placeOrder({
    required String idempotencyKey,
    required String cartId,
    required String addressId,
    required bool isGift,
    String? recipientName,
    String? recipientPhone,
    required String paymentMethod,
    String? paymentGateway,
  }) {
    return cartRepo.placeOrder(
      idempotencyKey: idempotencyKey,
      cartId: cartId,
      addressId: addressId,
      isGift: isGift,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      paymentMethod: paymentMethod,
      paymentGateway: paymentGateway,
    );
  }
}

@injectable
class ProcessPaymentUseCase {
  ProcessPaymentUseCase(this.cartRepo);

  final CartRepo cartRepo;

  Future<BaseResponse<PaymentCheckoutEntity>> createPaymentCheckout({
    required String orderId,
    required double amountTotal,
    required String currency,
  }) {
    return cartRepo.createPaymentCheckout(
      orderId: orderId,
      amountTotal: amountTotal,
      currency: currency,
    );
  }
}
