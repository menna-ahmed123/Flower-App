enum OrderStatus {
  placed,
  preparing,
  pickedUp,
  outForDelivery,
  arrived,
  awaitingDeliveryConfirmation,
  delivered,
  cancelled,
  unknown;

  static OrderStatus fromApi(String? raw) {
    final key = (raw ?? '').replaceAll(RegExp(r'[\s_\-]'), '').toLowerCase();
    switch (key) {
      case 'placed':
      case 'received':
        return placed;
      case 'preparing':
        return preparing;
      case 'pickedup':
        return pickedUp;
      case 'outfordelivery':
        return outForDelivery;
      case 'arrived':
        return arrived;
      case 'awaitingdeliveryconfirmation':
        return awaitingDeliveryConfirmation;
      case 'delivered':
        return delivered;
      case 'cancelled':
      case 'canceled':
        return cancelled;
      default:
        return unknown;
    }
  }

  bool get isFinished => this == delivered || this == cancelled;
  bool get isActive => !isFinished;
}

extension OrderStatusTimelineStep on OrderStatus {
  int get timelineStep {
    switch (this) {
      case OrderStatus.placed:
      case OrderStatus.unknown:
      case OrderStatus.cancelled:
        return 0;
      case OrderStatus.preparing:
      case OrderStatus.pickedUp:
        return 1;
      case OrderStatus.outForDelivery:
      case OrderStatus.arrived:
        return 2;
      case OrderStatus.awaitingDeliveryConfirmation:
        return 3;
      case OrderStatus.delivered:
        return 4;
    }
  }
}
