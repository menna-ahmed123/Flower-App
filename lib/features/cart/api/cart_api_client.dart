import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/api_query_params.dart';
import 'package:flower_app/features/cart/data/models/cart_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_preview_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_request.dart';
import 'package:flower_app/features/cart/data/models/order_response.dart';
import 'package:retrofit/retrofit.dart';

part 'cart_api_client.g.dart';

@RestApi()
abstract class CartApiClient {
  factory CartApiClient(Dio dio, {String baseUrl}) = _CartApiClient;

  @GET(ApiEndpoints.cart)
  Future<CartResponse> getCart();

  @POST(ApiEndpoints.cartItems)
  Future<AddCartItemResponse> addCartItem(@Body() AddCartItemRequest request);

  @PATCH(ApiEndpoints.cartItem)
  Future<CartResponse> updateCartItem(
    @Path(ApiQueryParams.itemId) String itemId,
    @Body() UpdateCartItemRequest request,
  );

  @DELETE(ApiEndpoints.cartItem)
  Future<CartResponse> removeCartItem(
    @Path(ApiQueryParams.itemId) String itemId,
  );

  @GET(ApiEndpoints.checkoutDetails)
  Future<CheckoutDetailsResponse> checkoutDetails(
    @Query(ApiQueryParams.cartId) String cartId,
  );

  @GET(ApiEndpoints.estimateDelivery)
  Future<HttpResponse<dynamic>> estimateDelivery(
    @Query(ApiQueryParams.estimateAddressId) String addressId,
    @Query(ApiQueryParams.estimateCartId) String cartId,
  );

  @POST(ApiEndpoints.placeOrder)
  Future<OrderResponse> placeOrder(
    @Header(ApiQueryParams.idempotencyKey) String idempotencyKey,
    @Body() PlaceOrderRequest request,
  );

  @POST(ApiEndpoints.paymentCheckout)
  Future<PaymentCheckoutResponse> createPaymentCheckout(
    @Body() PaymentCheckoutRequest request,
  );
}
