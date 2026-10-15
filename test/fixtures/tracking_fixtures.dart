import 'package:flower_app/features/order/domain/entities/driver_location_entity.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/timeline_step_entity.dart';
import 'package:flower_app/features/order/domain/entities/tracking_driver_entity.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';

const storePoint = GeoPoint(30.0500, 31.2300);
const homePoint = GeoPoint(30.0600, 31.2600);
const driverPoint = GeoPoint(30.0550, 31.2450);

const driver = TrackingDriverEntity(
  id: 'd1',
  name: 'Muhamed',
  phone: '01012345678',
);

/// The 7 timeline statuses the real API returns, in order.
const _timelineOrder = [
  OrderStatus.placed,
  OrderStatus.preparing,
  OrderStatus.pickedUp,
  OrderStatus.outForDelivery,
  OrderStatus.arrived,
  OrderStatus.awaitingDeliveryConfirmation,
  OrderStatus.delivered,
];

List<TimelineStepEntity> timelineFor(OrderStatus status) {
  final current = _timelineOrder.indexOf(status);
  return [
    for (var i = 0; i < _timelineOrder.length; i++)
      TimelineStepEntity(
        status: _timelineOrder[i],
        // Real sample: the current step is isCompleted:false, isCurrent:true.
        isCompleted: i < current || (status == OrderStatus.delivered && i == current),
        isCurrent: i == current,
        occurredAt: i <= current ? DateTime.utc(2024, 9, 3, 10 + i) : null,
      ),
  ];
}

TrackingEntity trackingFixture({
  OrderStatus status = OrderStatus.preparing,
  bool withDriver = true,
  bool withMapData = true,
  DateTime? recordedAt,
  DateTime? eta,
}) {
  return TrackingEntity(
    orderId: 'o1',
    orderNumber: 'ORD-1',
    status: status,
    isTrackingActive: true,
    timeline: timelineFor(status),
    driver: withDriver ? driver : null,
    driverLocation: (withDriver && withMapData)
        ? DriverLocationEntity(point: driverPoint, recordedAt: recordedAt)
        : null,
    destination: withMapData ? homePoint : null,
    storeLocation: withMapData ? storePoint : null,
    estimatedArrival: eta ?? DateTime.utc(2024, 9, 3, 11, 0),
  );
}

/// Mirrors the real Apidog response for a brand-new order (PLACED):
/// isTrackingActive false, no driver, no live location, no ETA, and the seeded
/// store sitting exactly on the customer's address.
TrackingEntity realPlacedSampleFixture() {
  const sameSpot = GeoPoint(30.0561, 31.3452);
  return TrackingEntity(
    orderId: 'ff301f8a-33c8-4d20-a58e-b9069f777cdb',
    orderNumber: 'ORD-20261011-6A8023',
    status: OrderStatus.placed,
    isTrackingActive: false,
    timeline: timelineFor(OrderStatus.placed)
        .map((s) => TimelineStepEntity(
              status: s.status,
              isCompleted: s.isCompleted,
              isCurrent: s.isCurrent,
            )) // occurredAt is null for every step in the real sample
        .toList(),
    destination: sameSpot,
    storeLocation: sameSpot,
  );
}
