import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/orders/domain/entities/order_details_entity.dart';
import 'package:flower_app/features/orders/domain/entities/order_summary_entity.dart';

abstract interface class OrdersRepo {
  Future<BaseResponse<List<OrderSummaryEntity>>> getOrders({required int page, required int pageSize});
  Future<BaseResponse<OrderDetailsEntity>> getOrderDetails(String id);
}
