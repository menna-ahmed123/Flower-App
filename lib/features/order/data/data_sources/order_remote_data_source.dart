import 'package:flower_app/core/base/api_response.dart';

import '../models/delivery_confirmation_model.dart';
import '../models/order_model.dart';
import '../models/order_tracking_model.dart';

abstract interface class OrderRemoteDataSource {
  Future<ApiResponse<List<OrderModel>>> getAllOrders({
    int? page,
    int? pageSize,
  });

  Future<ApiResponse<OrderTrackingModel>> orderTracking({
    required String orderId,
  });

  Future<ApiResponse<DeliveryConfirmationModel>> confirmDelivery({
    required String orderId,
  });
}