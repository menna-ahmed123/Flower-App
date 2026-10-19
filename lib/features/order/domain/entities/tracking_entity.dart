import 'package:equatable/equatable.dart';

import 'driver_location_entity.dart';
import 'geo_point.dart';
import 'order_status.dart';
import 'timeline_step_entity.dart';
import 'tracking_driver_entity.dart';

class TrackingEntity extends Equatable {
  const TrackingEntity({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.isTrackingActive,
    required this.timeline,
    this.driver,
    this.driverLocation,
    this.destination,
    this.storeLocation,
    this.estimatedArrival,
  });

  final String orderId;
  final String orderNumber;
  final OrderStatus status;
  final bool isTrackingActive;
  final List<TimelineStepEntity> timeline;
  final TrackingDriverEntity? driver;
  final DriverLocationEntity? driverLocation;
  final GeoPoint? destination;
  final GeoPoint? storeLocation;
  final DateTime? estimatedArrival;

  bool get isFinished => status.isFinished;
  bool get canConfirmDelivery =>
      status == OrderStatus.awaitingDeliveryConfirmation;
  int get uiStepIndex => status.timelineStep;

  TrackingEntity copyWith({
    OrderStatus? status,
    bool? isTrackingActive,
    List<TimelineStepEntity>? timeline,
    DateTime? estimatedArrival,
  }) {
    return TrackingEntity(
      orderId: orderId,
      orderNumber: orderNumber,
      status: status ?? this.status,
      isTrackingActive: isTrackingActive ?? this.isTrackingActive,
      timeline: timeline ?? this.timeline,
      driver: driver,
      driverLocation: driverLocation,
      destination: destination,
      storeLocation: storeLocation,
      estimatedArrival: estimatedArrival ?? this.estimatedArrival,
    );
  }

  @override
  List<Object?> get props => [
        orderId,
        orderNumber,
        status,
        isTrackingActive,
        timeline,
        driver,
        driverLocation,
        destination,
        storeLocation,
        estimatedArrival,
      ];
}
