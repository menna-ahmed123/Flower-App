import 'package:injectable/injectable.dart';

import '../../../../core/base/base_response.dart';
import '../entities/geo_point.dart';
import '../repos/order_repo.dart';

@Injectable()
class GetOrderRouteUseCase {
  final OrderRepo _orderRepo;
  GetOrderRouteUseCase(this._orderRepo);

  Future<BaseResponse<List<GeoPoint>>> call({
    required GeoPoint from,
    required GeoPoint to,
  }) {
    return _orderRepo.fetchRoute(from: from, to: to);
  }
}
