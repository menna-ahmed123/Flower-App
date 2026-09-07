import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_dto.g.dart';

@JsonSerializable(createFactory: false)
class AddressDto {
  final String id;
  final String recipientName;
  final String phone;
  final String addressLine;
  final String city;
  final String area;
  final double lat;
  final double lng;
  final String label;
  final String servingStoreId;
  final bool isServiceable;
  final bool isDefault;
  final DateTime? createdAtUtc;
  final DateTime? lastUsedAtUtc;

  AddressDto({
    required this.id,
    required this.recipientName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.area,
    required this.lat,
    required this.lng,
    required this.label,
    required this.servingStoreId,
    required this.isServiceable,
    required this.isDefault,
    this.createdAtUtc,
    this.lastUsedAtUtc,
  });

  factory AddressDto.fromJson(Map<String, dynamic> json) {
    return AddressDto(
      id: _string(json['id']),
      recipientName: _string(json['recipientName']),
      phone: _string(json['phone']),
      addressLine: _string(json['addressLine'] ?? json['address']),
      city: _string(json['city']),
      area: _string(json['area']),
      lat: _double(json['lat']),
      lng: _double(json['lng']),
      label: _string(json['label']),
      servingStoreId: _string(json['servingStoreId']),
      isServiceable: json['isServiceable'] as bool? ?? true,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAtUtc: _date(json['createdAtUtc']),
      lastUsedAtUtc: _date(json['lastUsedAtUtc']),
    );
  }

  Map<String, dynamic> toJson() => _$AddressDtoToJson(this);

  AddressEntity toDomain() {
    return AddressEntity(
      id: id,
      address: addressLine,
      phoneNumber: phone,
      recipientName: recipientName,
      city: city,
      area: area,
      label: label,
    );
  }
}

String _string(dynamic value) => value?.toString() ?? '';

double _double(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime? _date(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
