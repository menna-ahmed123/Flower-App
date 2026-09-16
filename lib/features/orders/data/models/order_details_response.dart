import 'package:flower_app/features/orders/data/models/order_details_dto.dart';
import 'package:flower_app/features/orders/domain/entities/order_details_entity.dart';

class OrderDetailsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final String messageLocalized;
  final OrderDetailsDto? data;

  OrderDetailsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.messageLocalized,
    required this.data,
  });

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return OrderDetailsResponse(
      success: json['success'] as bool? ?? true,
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 200,
      message: json['message']?.toString() ?? '',
      messageLocalized: json['messageLocalized']?.toString() ?? '',
      data: raw is Map ? OrderDetailsDto.fromJson(Map<String, dynamic>.from(raw)) : null,
    );
  }

  OrderDetailsEntity? toDomain() => data?.toDomain();
}
