import 'package:flower_app/core/base/api_response.dart';
import 'package:flower_app/features/order/data/api/order_api_client.dart';
import 'package:flower_app/features/order/data/data_sources/order_remote_data_source.dart';
import 'package:flower_app/features/order/data/models/order_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrderRemoteDataSource)
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final OrderApiClient orderApiClient;
  OrderRemoteDataSourceImpl(this.orderApiClient);

  @override
  Future<ApiResponse<List<OrderModel>>> getAllOrders({
    int? page,
    int? pageSize,
  }) {
    return orderApiClient.getAllOrders(
      page: page?.toString(),
      pageSize: pageSize?.toString(),
    );
  }
}