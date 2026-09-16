import 'package:flower_app/features/orders/data/models/order_details_response.dart';
import 'package:flower_app/features/orders/data/models/orders_list_response.dart';

abstract interface class OrdersRemoteDataSource {
  Future<OrdersListResponse> getOrders({required int page, required int pageSize});
  Future<OrderDetailsResponse> getOrderDetails(String id);
}
