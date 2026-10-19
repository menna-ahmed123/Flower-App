import 'package:injectable/injectable.dart';

import '../../../../core/base/base_response.dart';
import '../entities/order_entity.dart';
import '../entities/order_status.dart';
import '../repos/order_repo.dart';

@Injectable()
class GetAllOrdersUseCase {
  final OrderRepo _orderRepo;
  GetAllOrdersUseCase(this._orderRepo);
  Future<BaseResponse<List<OrderEntity>>> call({
    int? page,
    int? pageSize,
  }) async {
    return await _orderRepo.getAllOrders(page: page, pageSize: pageSize);
  }

  List<OrderEntity> activeOrders(List<OrderEntity> orders) =>
      _filterBy(orders, (status) => status.isActive);

  List<OrderEntity> completedOrders(List<OrderEntity> orders) =>
      _filterBy(orders, (status) => status.isFinished);

  List<OrderEntity> _filterBy(
    List<OrderEntity> orders,
    bool Function(OrderStatus status) test,
  ) {
    return orders.where((order) {
      final status = order.status;
      return status != null && test(status);
    }).toList();
  }
}
