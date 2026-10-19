import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/domain/entities/order_entity.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/order_card.dart';
import 'package:flutter/material.dart';

class MyOrderCard extends StatelessWidget {
  const MyOrderCard({
    super.key,
    required this.order,
    required this.onTrackOrder,
  });

  final OrderEntity order;
  final VoidCallback onTrackOrder;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      orderImageUrl: order.firstItemThumbnailUrl?.toString() ?? '',
      orderName: AppString.itemsCount(order.itemCount ?? 0),
      orderPrice: '${AppString.egp} ${(order.total ?? 0).toStringAsFixed(0)}',
      orderNumber: order.orderNumber ?? '',
      onTrackOrder: onTrackOrder,
    );
  }
}
