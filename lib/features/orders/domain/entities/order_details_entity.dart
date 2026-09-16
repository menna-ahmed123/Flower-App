import 'package:equatable/equatable.dart';
import 'package:flower_app/features/orders/domain/entities/order_item_entity.dart';
import 'package:flower_app/features/orders/domain/entities/order_status.dart';

class OrderDetailsEntity extends Equatable {
  final String id;
  final String orderNumber;
  final OrderStatus status;
  final List<OrderItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String recipientName;
  final String recipientPhone;
  final String deliveryAddressLine;
  final String deliveryCity;
  final String deliveryArea;
  final String paymentMethod;
  final DateTime? createdAt;
  final DateTime? deliveredAt;

  const OrderDetailsEntity({
    this.id = '',
    this.orderNumber = '',
    this.status = OrderStatus.placed,
    this.items = const [],
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.total = 0,
    this.recipientName = '',
    this.recipientPhone = '',
    this.deliveryAddressLine = '',
    this.deliveryCity = '',
    this.deliveryArea = '',
    this.paymentMethod = '',
    this.createdAt,
    this.deliveredAt,
  });

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        status,
        items,
        subtotal,
        deliveryFee,
        total,
        recipientName,
        recipientPhone,
        deliveryAddressLine,
        deliveryCity,
        deliveryArea,
        paymentMethod,
        createdAt,
        deliveredAt,
      ];
}
