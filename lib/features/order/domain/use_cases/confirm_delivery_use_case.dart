import 'package:injectable/injectable.dart';

import '../../../../core/base/base_response.dart';
import '../entities/delivery_confirmation_entity.dart';
import '../repos/order_repo.dart';

@Injectable()
class ConfirmDeliveryUseCase {
  final OrderRepo _orderRepo;
  ConfirmDeliveryUseCase(this._orderRepo);

  Future<BaseResponse<DeliveryConfirmationEntity>> call({required String orderId}) {
    return _orderRepo.confirmDelivery(orderId: orderId);
  }
}
