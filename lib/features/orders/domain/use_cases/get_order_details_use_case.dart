import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/orders/domain/entities/order_details_entity.dart';
import 'package:flower_app/features/orders/domain/repo/orders_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GetOrderDetailsUseCase {
  final OrdersRepo repo;

  GetOrderDetailsUseCase(this.repo);

  Future<BaseResponse<OrderDetailsEntity>> call(String orderId) {
    return repo.getOrderDetails(orderId);
  }
}
