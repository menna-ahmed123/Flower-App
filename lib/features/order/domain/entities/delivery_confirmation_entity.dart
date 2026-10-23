import 'package:equatable/equatable.dart';

import 'order_status.dart';

class DeliveryConfirmationEntity extends Equatable {
  const DeliveryConfirmationEntity({
    required this.orderId,
    required this.status,
    this.confirmedAt,
  });

  final String orderId;
  final OrderStatus status;
  final DateTime? confirmedAt;

  @override
  List<Object?> get props => [orderId, status, confirmedAt];
}
