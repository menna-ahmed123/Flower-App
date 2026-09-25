import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo/cart_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class PreviewCheckoutUseCase {
  PreviewCheckoutUseCase(this.cartRepo);

  final CartRepo cartRepo;

  Future<BaseResponse<CartEntity>> previewCheckout({
    String? addressId,
    CheckoutGiftEntity? gift,
  }) {
    return cartRepo.previewCheckout(addressId: addressId, gift: gift);
  }
}

@injectable
class PlaceOrderUseCase {
  PlaceOrderUseCase(this.cartRepo);

  final CartRepo cartRepo;

  Future<BaseResponse<OrderEntity>> placeOrder({
    required String idempotencyKey,
    required int paymentMethod,
    required double expectedTotal,
    String? addressId,
    CheckoutGiftEntity? gift,
  }) {
    return cartRepo.placeOrder(
      idempotencyKey: idempotencyKey,
      paymentMethod: paymentMethod,
      expectedTotal: expectedTotal,
      addressId: addressId,
      gift: gift,
    );
  }
}

@injectable
class ProcessPaymentUseCase {
  ProcessPaymentUseCase(this.cartRepo);

  final CartRepo cartRepo;

  Future<BaseResponse<bool>> processPayment() => cartRepo.processPayment();
}
