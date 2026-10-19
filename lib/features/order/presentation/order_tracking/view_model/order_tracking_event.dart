sealed class OrderTrackingEvent {}

class LoadOrderTracking extends OrderTrackingEvent {
  LoadOrderTracking(this.orderId);

  final String? orderId;
}

class WatchOrderTracking extends OrderTrackingEvent {
  WatchOrderTracking(this.orderId);

  final String? orderId;
}

class StopWatchingOrderTracking extends OrderTrackingEvent {}

class ConfirmOrderDelivered extends OrderTrackingEvent {}
