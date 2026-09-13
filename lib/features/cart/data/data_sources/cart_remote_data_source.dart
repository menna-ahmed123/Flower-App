import 'package:flower_app/features/cart/data/models/cart_models.dart';

abstract interface class CartRemoteDataSource {
  Future<CartResponse> getCart();

  Future<CartResponse> addCartItem(AddCartItemRequest request);

  Future<CartResponse> updateCartItem(String itemId, UpdateCartItemRequest request);

  Future<void> removeCartItem(String itemId);
}
