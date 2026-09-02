import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/api_query_params.dart';
import 'package:flower_app/features/cart/data/models/cart_models.dart';
import 'package:retrofit/retrofit.dart';

part 'cart_api_client.g.dart';

@RestApi()
abstract class CartApiClient {
  factory CartApiClient(Dio dio, {String baseUrl}) = _CartApiClient;

  @GET(ApiEndpoints.cart)
  Future<CartResponse> getCart(
    @Query(ApiQueryParams.storeId) String storeId,
  );

  @POST(ApiEndpoints.cartItems)
  Future<CartResponse> addCartItem(@Body() AddCartItemRequest request);

  @PUT(ApiEndpoints.cartItem)
  Future<CartResponse> updateCartItem(
    @Path(ApiQueryParams.id) String id,
    @Body() UpdateCartItemRequest request,
  );

  @DELETE(ApiEndpoints.cartItem)
  Future<void> removeCartItem(
    @Path(ApiQueryParams.id) String id,
    @Query(ApiQueryParams.storeId) String storeId,
  );
}
