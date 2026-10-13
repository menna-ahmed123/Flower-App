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

  /// The API uses "PLACED"/"OUT_FOR_DELIVERY" in some endpoints and
  /// "Placed" in others, so normalise before comparing.
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

  /// "Active" tab = anything not finished (unknown included, so nothing vanishes).
  bool get isActive => !isFinished;
}
