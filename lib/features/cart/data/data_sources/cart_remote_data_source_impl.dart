import 'package:flower_app/features/cart/api/cart_api_client.dart';
import 'package:flower_app/features/cart/data/data_sources/cart_remote_data_source.dart';
import 'package:flower_app/features/cart/data/models/cart_models.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CartRemoteDataSource)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  CartRemoteDataSourceImpl(this.cartApiClient);

  final CartApiClient cartApiClient;

  @override
  Future<CartResponse> getCart() {
    return cartApiClient.getCart();
  }

  @override
  Future<CartResponse> addCartItem(AddCartItemRequest request) {
    return cartApiClient.addCartItem(request);
  }

  @override
  Future<CartResponse> updateCartItem(
    String itemId,
    UpdateCartItemRequest request,
  ) {
    return cartApiClient.updateCartItem(itemId, request);
  }

  @override
  Future<void> removeCartItem(String itemId) {
    return cartApiClient.removeCartItem(itemId);
  }
}
