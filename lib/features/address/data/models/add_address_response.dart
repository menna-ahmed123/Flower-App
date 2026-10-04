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
    final rawSuccess = json['success'] ?? json['status'];
    final rawCode = json['statusCode'] ?? json['code'];
    final int code = (rawCode as num?)?.toInt() ?? 200;

    final bool isSuccess = rawSuccess == true ||
        (rawSuccess is String && rawSuccess.toLowerCase() == 'success') ||
        (code >= 200 && code < 300);

    return AddressResponse(
      success: isSuccess,
      statusCode: code,
      message: json['message']?.toString() ?? '',
      messageLocalized: json['messageLocalized']?.toString() ?? '',
      data: parseAddressList(json['data'] ?? json),
    );
  }

  List<AddressEntity> toDomain() {
    return data.map((address) => address.toDomain()).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'messageLocalized': messageLocalized,
      'data': data.map((address) => address.toJson()).toList(),
    };
  }
}

List<AddressDto> parseAddressList(dynamic raw) {
  if (raw == null) {
    return [];
  }

  if (raw is List) {
    return raw
        .whereType<Map>()
        .map(
          (item) => AddressDto.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  if (raw is Map) {
    final map = Map<String, dynamic>.from(raw);

    if (map['items'] != null) {
      return parseAddressList(map['items']);
    }

    if (map['addresses'] != null) {
      return parseAddressList(map['addresses']);
    }

    if (map['address'] != null) {
      return parseAddressList(map['address']);
    }

    if (map.containsKey('id') ||
        map.containsKey('addressLine') ||
        map.containsKey('address') ||
        map.containsKey('recipientName') ||
        map.containsKey('city')) {
      return [
        AddressDto.fromJson(map),
      ];
    }
  }

  return [];
}
