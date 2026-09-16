import 'package:flower_app/features/orders/data/models/order_item_dto.dart';
import 'package:flower_app/features/orders/domain/entities/order_status.dart';
import 'package:flower_app/features/orders/domain/entities/order_details_entity.dart';

// Provisional shape: not documented for customer orders. Pricing fields (subtotal/deliveryFee/total)
// mirror the Cart schema; delivery fields (recipientName/recipientPhone/deliveryAddressLine/
// deliveryCity/deliveryArea) mirror the driver-facing DriverOrderDetails schema for the same Order entity.
class OrderDetailsDto {
  final String id;
  final String orderNumber;
  final int status;
  final List<OrderItemDto> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String recipientName;
  final String recipientPhone;
  final String deliveryAddressLine;
  final String deliveryCity;
  final String deliveryArea;
  final String paymentMethod;
  final DateTime? createdAtUtc;
  final DateTime? deliveredAtUtc;

  OrderDetailsDto({
    this.id = '',
    this.orderNumber = '',
    this.status = 0,
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
    this.createdAtUtc,
    this.deliveredAtUtc,
  });

  factory OrderDetailsDto.fromJson(Map<String, dynamic> json) {
    final orderNumberValue = [
      json['orderNumber'],
      json['number'],
    ].firstWhere((value) => value != null && value.toString().trim().isNotEmpty, orElse: () => '');

    final addressLineValue = [
      json['deliveryAddressLine'],
      json['addressLine'],
      json['address'],
    ].firstWhere((value) => value != null && value.toString().trim().isNotEmpty, orElse: () => '');

    final itemsRaw = json['items'];
    final items = itemsRaw is List
        ? [for (final item in itemsRaw) if (item is Map) OrderItemDto.fromJson(Map<String, dynamic>.from(item))]
        : <OrderItemDto>[];

    return OrderDetailsDto(
      id: json['id']?.toString() ?? '',
      orderNumber: orderNumberValue.toString(),
      status: (json['status'] as num?)?.toInt() ?? 0,
      items: items,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      recipientName: json['recipientName']?.toString() ?? '',
      recipientPhone: json['recipientPhone']?.toString() ?? '',
      deliveryAddressLine: addressLineValue.toString(),
      deliveryCity: json['deliveryCity']?.toString() ?? '',
      deliveryArea: json['deliveryArea']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      createdAtUtc: json['createdAtUtc'] == null ? null : DateTime.tryParse(json['createdAtUtc'].toString()),
      deliveredAtUtc: json['deliveredAtUtc'] == null ? null : DateTime.tryParse(json['deliveredAtUtc'].toString()),
    );
  }

  OrderDetailsEntity toDomain() {
    return OrderDetailsEntity(
      id: id,
      orderNumber: orderNumber,
      status: status.toOrderStatus(),
      items: [for (final item in items) item.toDomain()],
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      deliveryAddressLine: deliveryAddressLine,
      deliveryCity: deliveryCity,
      deliveryArea: deliveryArea,
      paymentMethod: paymentMethod,
      createdAt: createdAtUtc,
      deliveredAt: deliveredAtUtc,
    );
  }
}
