/// Order lifecycle status as documented by the Orders & Fulfillment OpenAPI contract.
enum OrderStatus { placed, preparing, pickedUp, outForDelivery, delivered, cancelled }

extension OrderStatusMapper on int {
  OrderStatus toOrderStatus() {
    return switch (this) {
      0 => OrderStatus.placed,
      1 => OrderStatus.preparing,
      2 => OrderStatus.pickedUp,
      3 => OrderStatus.outForDelivery,
      4 => OrderStatus.delivered,
      5 => OrderStatus.cancelled,
      _ => OrderStatus.placed,
    };
  }
}

extension OrderStatusGroup on OrderStatus {
  bool get isActive => this != OrderStatus.delivered && this != OrderStatus.cancelled;
  bool get isCompleted => !isActive;
}
