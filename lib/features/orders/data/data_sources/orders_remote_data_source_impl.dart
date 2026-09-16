import 'package:flower_app/features/orders/api/orders_api_client.dart';
import 'package:flower_app/features/orders/data/data_sources/orders_remote_data_source.dart';
import 'package:flower_app/features/orders/data/models/order_details_response.dart';
import 'package:flower_app/features/orders/data/models/orders_list_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final OrdersApiClient ordersApiClient;

  OrdersRemoteDataSourceImpl({required this.ordersApiClient});

  @override
  Future<OrdersListResponse> getOrders({required int page, required int pageSize}) {
    return ordersApiClient.getOrders(page, pageSize);
  }

  @override
  Future<OrderDetailsResponse> getOrderDetails(String id) {
    return ordersApiClient.getOrderDetails(id);
  }
}
