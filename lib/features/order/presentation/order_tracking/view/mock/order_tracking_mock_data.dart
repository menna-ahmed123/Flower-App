
import 'package:flower_app/features/order/domain/entities/driver_location_entity.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/timeline_step_entity.dart';
import 'package:flower_app/features/order/domain/entities/tracking_driver_entity.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';

class OrderTrackingMockData {
  OrderTrackingMockData._();

  static final DateTime _now = DateTime.now().toUtc();

  static const TrackingDriverEntity driver = TrackingDriverEntity(
    id: 'driver-001',
    name: 'Ahmed Mohamed',
    phone: '+201000000000',
    imageUrl: null,
  );

  // المحل في الدقي
  static const GeoPoint pickup = GeoPoint(30.0566, 31.2394);

  // العميل في مدينة نصر
  static const GeoPoint destination = GeoPoint(30.0680, 31.3400);

  // الخط يمر على طرق حقيقية: الدقي → العجوزة → المهندسين → مصر الجديدة → مدينة نصر
  static const List<GeoPoint> routePoints = [
    GeoPoint(30.0566, 31.2394), // المحل (الدقي)
    GeoPoint(30.0600, 31.2500), // العجوزة
    GeoPoint(30.0630, 31.2700), // المهندسين
    GeoPoint(30.0650, 31.2900), // مصر الجديدة
    GeoPoint(30.0670, 31.3200), // بين مصر الجديدة ومدينة نصر
    GeoPoint(30.0680, 31.3400), // مدينة نصر
  ];

  // السائق في منتصف الطريق (المهندسين)
  static final DriverLocationEntity driverLocation = DriverLocationEntity(
    point: const GeoPoint(30.0630, 31.2700),
    recordedAt: _now.subtract(const Duration(minutes: 1)),
  );

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
    storeLocation: pickup,
    destination: destination,
    estimatedArrival: _now.add(const Duration(minutes: 15)),
  );
}
