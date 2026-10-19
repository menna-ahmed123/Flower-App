import 'package:flower_app/core/base/base_response.dart';
import '../entities/order_entity.dart';

abstract interface class OrderRepo {
  Future<BaseResponse<List<OrderEntity>>> getAllOrders({
    int? page,
    int? pageSize,
  });
}