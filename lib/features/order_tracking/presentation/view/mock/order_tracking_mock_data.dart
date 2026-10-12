
import '../../../domain/entities/driver_location_entity.dart';
import '../../../domain/entities/geo_point.dart';
import '../../../domain/entities/order_status.dart';
import '../../../domain/entities/timeline_step_entity.dart';
import '../../../domain/entities/tracking_driver_entity.dart';
import '../../../domain/entities/tracking_entity.dart';

class OrderTrackingMockData {
  OrderTrackingMockData._();

  static final DateTime _now = DateTime.now().toUtc();

  static const TrackingDriverEntity driver = TrackingDriverEntity(
    id: 'driver-001',
    name: 'Ahmed Mohamed',
    phone: '+201000000000',
    imageUrl: null,
  );

  static final DriverLocationEntity driverLocation = DriverLocationEntity(
    point: const GeoPoint(30.0444, 31.2357),
    recordedAt: _now.subtract(const Duration(minutes: 1)),
  );

  static const GeoPoint pickup = GeoPoint(30.0566, 31.2394);

  static const GeoPoint destination = GeoPoint(30.0131, 31.2089);

  static final List<TimelineStepEntity> timeline = [
    TimelineStepEntity(
      status: OrderStatus.placed,
      isCompleted: true,
      isCurrent: false,
      occurredAt: _now.subtract(const Duration(minutes: 30)),
    ),
    TimelineStepEntity(
      status: OrderStatus.preparing,
      isCompleted: true,
      isCurrent: false,
      occurredAt: _now.subtract(const Duration(minutes: 20)),
    ),
    TimelineStepEntity(
      status: OrderStatus.outForDelivery,
      isCompleted: false,
      isCurrent: true,
      occurredAt: _now.subtract(const Duration(minutes: 5)),
    ),
    const TimelineStepEntity(
      status: OrderStatus.delivered,
      isCompleted: false,
      isCurrent: false,
    ),
  ];

  static final TrackingEntity tracking = TrackingEntity(
    orderId: 'order-001',
    orderNumber: '#ORD-2026-001',
    status: OrderStatus.outForDelivery,
    isTrackingActive: true,
    timeline: timeline,
    driver: driver,
    driverLocation: driverLocation,
    pickup: pickup,
    destination: destination,
    estimatedArrival: _now.add(const Duration(minutes: 15)),
  );

  static const List<GeoPoint> routePoints = [
    GeoPoint(30.0566, 31.2394),
    GeoPoint(30.0500, 31.2350),
    GeoPoint(30.0444, 31.2357),
    GeoPoint(30.0350, 31.2250),
    GeoPoint(30.0131, 31.2089),
  ];
}
