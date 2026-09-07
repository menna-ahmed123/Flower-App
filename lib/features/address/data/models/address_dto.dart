import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'address_dto.g.dart';


@JsonSerializable()
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

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);

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
      isDefault: isDefault,
    );
  }
}