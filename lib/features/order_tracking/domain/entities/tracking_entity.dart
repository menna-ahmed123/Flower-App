import 'package:equatable/equatable.dart';

import 'driver_location_entity.dart';
import 'geo_point.dart';
import 'order_status.dart';
import 'timeline_step_entity.dart';
import 'tracking_driver_entity.dart';

typedef TrackingUiStep = ({String title, DateTime? time});

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

  /// null => "waiting for driver".
  final TrackingDriverEntity? driver;
  final DriverLocationEntity? driverLocation;
  final GeoPoint? destination;
  /// Route start. API key: `storeLocation`.
  final GeoPoint? storeLocation;
  final DateTime? estimatedArrival;

  bool get isFinished => status.isFinished;

  /// "Order Delivered" (customer confirms) shows only while the backend waits
  /// for the customer: AWAITING_DELIVERY_CONFIRMATION. Verify with the driver flow.
  bool get canConfirmDelivery =>
      status == OrderStatus.awaitingDeliveryConfirmation;

  /// Backend has 7 statuses, Figma has 4 steps. `4` (past the last step) means
  /// everything is done, so the timeline shows all checkmarks.
  int get uiStepIndex {
    switch (status) {
      case OrderStatus.placed:
      case OrderStatus.unknown:
      case OrderStatus.cancelled:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.pickedUp:
      case OrderStatus.outForDelivery:
      case OrderStatus.arrived:
      case OrderStatus.awaitingDeliveryConfirmation:
        return 2;
      case OrderStatus.delivered:
        return 4;
    }
  }

  List<TrackingUiStep> get uiSteps => [
        (title: 'Received your order', time: _timeOf([OrderStatus.placed])),
        (title: 'Preparing your order', time: _timeOf([OrderStatus.preparing])),
        (
          title: 'Out for delivery',
          time: _timeOf([OrderStatus.outForDelivery, OrderStatus.pickedUp]),
        ),
        (title: 'Delivered', time: _timeOf([OrderStatus.delivered])),
      ];

  DateTime? _timeOf(List<OrderStatus> statuses) {
    for (final s in statuses) {
      for (final step in timeline) {
        if (step.status == s && step.occurredAt != null) return step.occurredAt;
      }
    }
    return null;
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
