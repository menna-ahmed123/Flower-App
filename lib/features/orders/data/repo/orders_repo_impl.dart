import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/orders/data/data_sources/orders_remote_data_source.dart';
import 'package:flower_app/features/orders/domain/entities/order_details_entity.dart';
import 'package:flower_app/features/orders/domain/entities/order_summary_entity.dart';
import 'package:flower_app/features/orders/domain/repo/orders_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrdersRepo)
class OrdersRepoImpl implements OrdersRepo {
  final SafeCall safeCall;
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepoImpl(this.safeCall, this.remoteDataSource);

  @override
  Future<BaseResponse<List<OrderSummaryEntity>>> getOrders({required int page, required int pageSize}) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.getOrders(page: page, pageSize: pageSize);
      return response.toDomain();
    });
  }

  @override
  Future<BaseResponse<OrderDetailsEntity>> getOrderDetails(String id) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.getOrderDetails(id);
      final order = response.toDomain();
      if (order == null) {
        throw ApiException(message: AppString.couldNotGetOrderDetails);
      }
      return order;
    });
  }
}
