import 'package:flower_app/features/cart/data/models/cart_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_preview_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_request.dart';
import 'package:flower_app/features/cart/data/models/order_response.dart';

abstract interface class CartRemoteDataSource {
  Future<CartResponse> getCart();

  Future<AddCartItemResponse> addCartItem(AddCartItemRequest request);

  Future<CartResponse> updateCartItem(
    String itemId,
    UpdateCartItemRequest request,
  );

  Future<CartResponse> removeCartItem(String itemId);

  Future<CheckoutDetailsResponse> checkoutDetails(String cartId);

  Future<EstimateDeliveryResponse> estimateDelivery({
    required String addressId,
    required String cartId,
  });

  Future<OrderResponse> placeOrder(
    String idempotencyKey,
    PlaceOrderRequest request,
  );

  Future<PaymentCheckoutResponse> createPaymentCheckout(
    PaymentCheckoutRequest request,
  );
}
