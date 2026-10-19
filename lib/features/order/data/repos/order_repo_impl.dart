import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/order/data/data_sources/order_remote_data_source.dart';
import 'package:flower_app/features/order/domain/entities/order_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/api_response.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/safe_call.dart';
import '../../domain/repos/order_repo.dart';
import '../mapper/order_model_mapper.dart';
import '../models/order_model.dart';
@Injectable(as: OrderRepo)
class OrderRepoImpl implements OrderRepo {
  final OrderRemoteDataSource orderRemoteDataSource;
  final SafeCall safeCall;
  OrderRepoImpl(this.orderRemoteDataSource , this.safeCall);

  @override
  Future<BaseResponse<List<OrderEntity>>> getAllOrders({
    int? page,
    int? pageSize,
  }) {
   return safeCall.safeApiCall (() async {
      final response = await orderRemoteDataSource.getAllOrders(
        page: page,
        pageSize: pageSize,
      );
      _validateResponse(response);
      return response.data!.map((e) => e.toDomain()).toList();
   });
  }
  void _validateResponse(ApiResponse<List<OrderModel>> response) {
    if (!response.status || response.errors != null || response.data == null) {
      throw ApiException(
        message: response.errorMessage,
        statusCode: response.code,
      );
    }
  }
}