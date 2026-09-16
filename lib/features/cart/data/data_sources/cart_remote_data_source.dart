import 'package:flower_app/features/cart/data/models/cart_models.dart';

abstract interface class CartRemoteDataSource {
  Future<CartResponse> getCart();

  Future<CartResponse> addCartItem(AddCartItemRequest request);

  Future<CartResponse> updateCartItem(
    String itemId,
    UpdateCartItemRequest request,
  );

  Future<void> removeCartItem(String itemId);

  Future<CartResponse> previewCheckout(CheckoutRequest request);

  Future<OrderResponse> placeOrder(
    String idempotencyKey,
    CheckoutRequest request,
  );

  Future<void> processPayment();
}
