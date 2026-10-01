import 'package:flower_app/core/constants/api_query_params.dart';
import 'package:flower_app/features/cart/api/cart_api_client.dart';
import 'package:flower_app/features/cart/data/data_sources/cart_remote_data_source.dart';
import 'package:flower_app/features/cart/data/models/cart_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_preview_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_request.dart';
import 'package:flower_app/features/cart/data/models/order_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CartRemoteDataSource)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  CartRemoteDataSourceImpl(this.cartApiClient);

  final CartApiClient cartApiClient;

  @override
  Future<CartResponse> getCart() {
    return cartApiClient.getCart(ApiQueryParams.defaultStoreId);
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
    return cartApiClient.removeCartItem(itemId, ApiQueryParams.defaultStoreId);
  }

  @override
  Future<CheckoutPreviewResponse> previewCheckout(CheckoutRequest request) {
    return cartApiClient.previewCheckout(request);
  }

  @override
  Future<OrderResponse> placeOrder(
    String idempotencyKey,
    CheckoutRequest request,
  ) {
    return cartApiClient.placeOrder(idempotencyKey, request);
  }

  @override
  Future<void> processPayment() => cartApiClient.processPayment();
}
