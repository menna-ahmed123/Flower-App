import 'package:flower_app/features/orders/data/models/order_item_dto.dart';
import 'package:flower_app/features/orders/domain/entities/order_status.dart';
import 'package:flower_app/features/orders/domain/entities/order_summary_entity.dart';

// Provisional shape: not documented for customer orders, but subtotal/deliveryFee/total mirror the
// sibling Cart schema's exact field names and types (OpenAPI: Cart.subtotal/deliveryFee/total).
class OrderSummaryDto {
  final String id;
  final String orderNumber;
  final int status;
  final List<OrderItemDto> items;
  final double totalPrice;
  final DateTime? createdAtUtc;
  final DateTime? deliveredAtUtc;

  OrderSummaryDto({
    this.id = '',
    this.orderNumber = '',
    this.status = 0,
    this.items = const [],
    this.totalPrice = 0,
    this.createdAtUtc,
    this.deliveredAtUtc,
  });

  factory OrderSummaryDto.fromJson(Map<String, dynamic> json) {
    final orderNumberValue = [
      json['orderNumber'],
      json['number'],
    ].firstWhere((value) => value != null && value.toString().trim().isNotEmpty, orElse: () => '');

    final itemsRaw = json['items'];
    final items = itemsRaw is List
        ? [for (final item in itemsRaw) if (item is Map) OrderItemDto.fromJson(Map<String, dynamic>.from(item))]
        : <OrderItemDto>[];

    return OrderSummaryDto(
      id: json['id']?.toString() ?? '',
      orderNumber: orderNumberValue.toString(),
      status: (json['status'] as num?)?.toInt() ?? 0,
      items: items,
      totalPrice: (json['total'] as num?)?.toDouble() ?? (json['totalPrice'] as num?)?.toDouble() ?? 0,
      createdAtUtc: json['createdAtUtc'] == null ? null : DateTime.tryParse(json['createdAtUtc'].toString()),
      deliveredAtUtc: json['deliveredAtUtc'] == null ? null : DateTime.tryParse(json['deliveredAtUtc'].toString()),
    );
  }

  OrderSummaryEntity toDomain() {
    final firstItem = items.isNotEmpty ? items.first : null;
    return OrderSummaryEntity(
      id: id,
      orderNumber: orderNumber,
      status: status.toOrderStatus(),
      previewImageUrl: firstItem?.imageUrl ?? '',
      previewProductName: firstItem?.productName ?? '',
      totalPrice: totalPrice,
      createdAt: createdAtUtc,
      deliveredAt: deliveredAtUtc,
    );
  }
}
