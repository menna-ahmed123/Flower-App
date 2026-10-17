import 'package:equatable/equatable.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';

class OrderEntity extends Equatable{
  final String? id;
  final String? orderNumber;
  final String? createdAt;
  final int? itemCount;
  final dynamic firstItemThumbnailUrl;
  final OrderStatus? status;
  final double? total;
  final String? paymentStatus;

  const OrderEntity ({
    this.id,
    this.orderNumber,
    this.createdAt,
    this.itemCount,
    this.firstItemThumbnailUrl,
    this.status,
    this.total,
    this.paymentStatus,
  });

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    createdAt,
    itemCount,
    firstItemThumbnailUrl,
    status,
    total,
    paymentStatus,
  ];
}
