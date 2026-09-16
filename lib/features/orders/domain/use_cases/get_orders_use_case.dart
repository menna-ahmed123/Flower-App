import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/orders/domain/entities/order_summary_entity.dart';
import 'package:flower_app/features/orders/domain/repo/orders_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GetOrdersUseCase {
  final OrdersRepo repo;

  GetOrdersUseCase(this.repo);

  Future<BaseResponse<List<OrderSummaryEntity>>> call({int page = 1, int pageSize = 50}) {
    return repo.getOrders(page: page, pageSize: pageSize);
  }
}
