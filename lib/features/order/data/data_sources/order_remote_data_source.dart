import 'package:flower_app/core/base/api_response.dart';

import '../models/order_model.dart';

abstract interface class OrderRemoteDataSource {
  Future<ApiResponse<List<OrderModel>>> getAllOrders({
    int? page,
    int? pageSize,
  });
}