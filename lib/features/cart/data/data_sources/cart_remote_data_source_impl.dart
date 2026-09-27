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
  Future<CartResponse> getCart() => cartApiClient.getCart();

  @override
  Future<AddCartItemResponse> addCartItem(AddCartItemRequest request) {
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
  Future<CartResponse> removeCartItem(String itemId) {
    return cartApiClient.removeCartItem(itemId);
  }

  @override
  Future<CheckoutDetailsResponse> checkoutDetails(String cartId) {
    return cartApiClient.checkoutDetails(cartId);
  }

  @override
  Future<EstimateDeliveryResponse> estimateDelivery({
    required String addressId,
    required String cartId,
  }) async {
    final response = await cartApiClient.estimateDelivery(addressId, cartId);
    return EstimateDeliveryResponse.parse(response.data);
  }

  @override
  Future<OrderResponse> placeOrder(
    String idempotencyKey,
    PlaceOrderRequest request,
  ) {
    return cartApiClient.placeOrder(idempotencyKey, request);
  }

  @override
  Future<PaymentCheckoutResponse> createPaymentCheckout(
    PaymentCheckoutRequest request,
  ) {
    return cartApiClient.createPaymentCheckout(request);
  }
}
