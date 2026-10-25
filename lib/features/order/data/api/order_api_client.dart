import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../../core/base/api_response.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/api_request_params.dart';
import '../models/delivery_confirmation_model.dart';
import '../models/order_model.dart';
import '../models/order_tracking_model.dart';
part 'order_api_client.g.dart';

@RestApi()
abstract class OrderApiClient {
  factory OrderApiClient(Dio dio, {String baseUrl}) = _OrderApiClient;

  @GET(ApiEndpoints.getAllOrders)
  Future<ApiResponse<List<OrderModel>>> getAllOrders({
    @Query(ApiRequestParams.page) String? page,
    @Query(ApiRequestParams.pageSize) String? pageSize,
  });

  @GET(ApiEndpoints.orderTracking)
  Future<ApiResponse<OrderTrackingModel>> getOrderTracking({
    @Path(ApiRequestParams.orderId) required String orderId,
  });

  @POST(ApiEndpoints.confirmDelivery)
  Future<ApiResponse<DeliveryConfirmationModel>> confirmDelivery({
    @Path(ApiRequestParams.orderId) required String orderId,
  });
}