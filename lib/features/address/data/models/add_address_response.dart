import 'package:flower_app/features/address/data/models/address_dto.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';

class AddressResponse {
  final bool success;
  final int statusCode;
  final String message;
  final String messageLocalized;
  final List<AddressDto> data;

  AddressResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.messageLocalized,
    required this.data,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      success: json['success'] as bool? ?? true,
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 200,
      message: json['message']?.toString() ?? '',
      messageLocalized: json['messageLocalized']?.toString() ?? '',
      data: parseAddressList(json['data']),
    );
  }

  List<AddressEntity> toDomain() {
    return data.map((address) => address.toDomain()).toList();
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'statusCode': statusCode,
    'message': message,
    'messageLocalized': messageLocalized,
    'data': data.map((address) => address.toJson()).toList(),
  };
}

List<AddressDto> parseAddressList(dynamic raw) {
  if (raw == null) return const [];

  if (raw is List) {
    return [
      for (final item in raw)
        if (item is Map)
          AddressDto.fromJson(Map<String, dynamic>.from(item)),
    ];
  }

  if (raw is Map) {
    final map = Map<String, dynamic>.from(raw);
    final nested = map['items'] ?? map['addresses'];
    if (nested != null) return parseAddressList(nested);
    if (map.containsKey('id') ||
        map.containsKey('addressLine') ||
        map.containsKey('city')) {
      return [AddressDto.fromJson(map)];
    }
  }

  return const [];
}
