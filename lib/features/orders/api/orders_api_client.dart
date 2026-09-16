import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/api_query_params.dart';
import 'package:flower_app/features/orders/data/models/order_details_response.dart';
import 'package:flower_app/features/orders/data/models/orders_list_response.dart';
import 'package:retrofit/retrofit.dart';

part 'orders_api_client.g.dart';

@RestApi()
abstract class OrdersApiClient {
  factory OrdersApiClient(Dio dio, {String baseUrl}) = _OrdersApiClient;

  @GET(ApiEndpoints.orders)
  Future<OrdersListResponse> getOrders(
    @Query(ApiQueryParams.page) int page,
    @Query(ApiQueryParams.pageSize) int pageSize,
  );

  @GET(ApiEndpoints.orderDetails)
  Future<OrderDetailsResponse> getOrderDetails(@Path(ApiQueryParams.id) String id);
}
