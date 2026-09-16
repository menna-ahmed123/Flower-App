sealed class OrderDetailsEvent {}

class OrderDetailsRequested extends OrderDetailsEvent {
  final String orderId;
  OrderDetailsRequested(this.orderId);
}
