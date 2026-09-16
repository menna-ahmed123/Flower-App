import 'package:equatable/equatable.dart';
import 'package:flower_app/features/orders/domain/entities/order_status.dart';

class OrderSummaryEntity extends Equatable {
  final String id;
  final String orderNumber;
  final OrderStatus status;
  final String previewImageUrl;
  final String previewProductName;
  final double totalPrice;
  final DateTime? createdAt;
  final DateTime? deliveredAt;

  const OrderSummaryEntity({
    this.id = '',
    this.orderNumber = '',
    this.status = OrderStatus.placed,
    this.previewImageUrl = '',
    this.previewProductName = '',
    this.totalPrice = 0,
    this.createdAt,
    this.deliveredAt,
  });

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        status,
        previewImageUrl,
        previewProductName,
        totalPrice,
        createdAt,
        deliveredAt,
      ];
}
