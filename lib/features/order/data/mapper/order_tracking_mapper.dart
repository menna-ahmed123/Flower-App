import 'package:flower_app/features/order/data/models/order_tracking_model.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';

import '../../domain/entities/driver_location_entity.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/entities/timeline_step_entity.dart';
import '../../domain/entities/tracking_driver_entity.dart';
import '../../domain/entities/tracking_entity.dart';

extension OrderTrackingMapper on OrderTrackingModel {
  TrackingEntity toDomain() {
    return TrackingEntity(
      status: OrderStatus.fromApi(status),
      orderId: orderId,
      isTrackingActive: isTrackingActive ?? false,
      orderNumber: orderNumber ?? '',
      timeline: timeline?.toDomain() ?? [],
      destination: destination != null
          ? GeoPoint(destination!.lat ?? 0, destination!.lng ?? 0)
          : null,
      driver: driver?.toDomain(),
      driverLocation: lastKnownLocation?.toDomain(),
      storeLocation: storeLocation != null
          ? GeoPoint(storeLocation!.lat ?? 0, storeLocation!.lng ?? 0)
          : null,
    );
  }
}

extension TimelineMapper on List<Timeline> {
  List<TimelineStepEntity> toDomain() {
    return map(
      (e) => TimelineStepEntity(
        status: OrderStatus.fromApi(e.status),
        isCompleted: e.isCompleted ?? false,
        isCurrent: e.isCurrent ?? false,
        occurredAt: e.occurredAt != null ? DateTime.parse(e.occurredAt!) : null,
      ),
    ).toList();
  }
}

extension DriverMapper on Driver {
  TrackingDriverEntity toDomain() {
    return TrackingDriverEntity(
      id: driverId ?? '',
      name: name ?? '',
      phone: phone ?? '',
      imageUrl: imageUrl,
    );
  }
}

extension LastKnownLocationMapper on LastKnownLocation {
  DriverLocationEntity toDomain() {
    return DriverLocationEntity(
      point: GeoPoint(lat ?? 0, lng ?? 0),
      recordedAt: recordedAt != null ? DateTime.parse(recordedAt!) : null,
      ageSeconds: ageSeconds ?? 0,
      isStale: isStale ?? false,
    );
  }
}
