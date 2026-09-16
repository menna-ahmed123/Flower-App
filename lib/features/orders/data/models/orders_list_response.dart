import 'package:flower_app/features/orders/data/models/order_summary_dto.dart';
import 'package:flower_app/features/orders/domain/entities/order_summary_entity.dart';

class OrdersListResponse {
  final bool success;
  final int statusCode;
  final String message;
  final String messageLocalized;
  final List<OrderSummaryDto> data;

  OrdersListResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.messageLocalized,
    required this.data,
  });

  factory OrdersListResponse.fromJson(Map<String, dynamic> json) {
    return OrdersListResponse(
      success: json['success'] as bool? ?? true,
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 200,
      message: json['message']?.toString() ?? '',
      messageLocalized: json['messageLocalized']?.toString() ?? '',
      data: parseOrderSummaryList(json['data']),
    );
  }

  List<OrderSummaryEntity> toDomain() {
    return data.map((order) => order.toDomain()).toList();
  }
}

// The list payload is expected to be paginated (`data.items`), matching the collection's test script; a bare list is also accepted defensively.
List<OrderSummaryDto> parseOrderSummaryList(dynamic raw) {
  if (raw == null) return const [];

  if (raw is List) {
    return [for (final item in raw) if (item is Map) OrderSummaryDto.fromJson(Map<String, dynamic>.from(item))];
  }

  if (raw is Map) {
    final map = Map<String, dynamic>.from(raw);
    final nested = map['items'] ?? map['orders'];
    if (nested != null) return parseOrderSummaryList(nested);
  }

  return const [];
}
