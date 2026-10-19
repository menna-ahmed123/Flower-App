import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';

const List<OrderStatus> trackingTimelineSteps = [
  OrderStatus.placed,
  OrderStatus.preparing,
  OrderStatus.outForDelivery,
  OrderStatus.delivered,
];

extension OrderStatusTrackingLabel on OrderStatus {
  String get trackingLabel {
    switch (this) {
      case OrderStatus.placed:
        return AppString.trackingStepReceived;
      case OrderStatus.preparing:
        return AppString.trackingStepPreparing;
      case OrderStatus.pickedUp:
        return AppString.statusPickedUp;
      case OrderStatus.outForDelivery:
        return AppString.trackingStepOutForDelivery;
      case OrderStatus.arrived:
        return AppString.statusArrived;
      case OrderStatus.awaitingDeliveryConfirmation:
        return AppString.statusAwaitingDeliveryConfirmation;
      case OrderStatus.delivered:
        return AppString.statusDelivered;
      case OrderStatus.cancelled:
        return AppString.statusCancelled;
      case OrderStatus.unknown:
        return AppString.unknown;
    }
  }
}
