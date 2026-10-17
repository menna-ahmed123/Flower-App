import 'package:flower_app/features/order/data/models/order_model.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';

extension OrderModelMapper on OrderModel {
  OrderEntity toDomain() {
    return OrderEntity(
      id: id,
      createdAt: createdAt,
      status: OrderStatus.fromApi(status),
      firstItemThumbnailUrl: firstItemThumbnailUrl,
      itemCount: itemCount,
      orderNumber: orderNumber,
      total: total,
      paymentStatus: paymentStatus,
    );
  }
}