import 'package:injectable/injectable.dart';

import '../entities/tracking_entity.dart';
import '../repos/order_repo.dart';

@Injectable()
class WatchOrderTrackingUseCase {
  final OrderRepo _orderRepo;
  WatchOrderTrackingUseCase(this._orderRepo);

  Stream<TrackingEntity> call({required String orderId}) {
    return _orderRepo.watchTracking(orderId: orderId);
  }
}
