import 'package:flower_app/core/base/base_response.dart';
import '../entities/delivery_confirmation_entity.dart';
import '../entities/geo_point.dart';
import '../entities/order_entity.dart';
import '../entities/tracking_entity.dart';

abstract interface class OrderRepo {
  Future<BaseResponse<List<OrderEntity>>> getAllOrders({
    int? page,
    int? pageSize,
  });

  Future<BaseResponse<TrackingEntity>> orderTracking({
    required String orderId,
  });

  Future<BaseResponse<DeliveryConfirmationEntity>> confirmDelivery({
    required String orderId,
  });

  Future<BaseResponse<List<GeoPoint>>> fetchRoute({
    required GeoPoint from,
    required GeoPoint to,
  });

  Stream<TrackingEntity> watchTracking({required String orderId});
}