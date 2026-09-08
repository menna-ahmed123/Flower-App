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
    this.id = '',
    this.recipientName = '',
    this.phone = '',
    this.addressLine = '',
    this.city = '',
    this.area = '',
    this.lat = 0,
    this.lng = 0,
    this.label = 'Home',
    this.servingStoreId = '',
    this.isServiceable = false,
    this.isDefault = false,
    this.createdAtUtc,
    this.lastUsedAtUtc,
  });

  factory AddressDto.fromJson(Map<String, dynamic> json) {
    final addressLineValue = [
      json['addressLine'],
      json['address'],
      json['fullAddress'],
      json['street'],
    ].firstWhere(
      (value) => value != null && value.toString().trim().isNotEmpty,
      orElse: () => '',
    );

    final recipientNameValue = [
      json['recipientName'],
      json['name'],
      json['customerName'],
    ].firstWhere(
      (value) => value != null && value.toString().trim().isNotEmpty,
      orElse: () => '',
    );

    final phoneValue = [
      json['phone'],
      json['phoneNumber'],
      json['mobile'],
    ].firstWhere(
      (value) => value != null && value.toString().trim().isNotEmpty,
      orElse: () => '',
    );

    final cityValue = [
      json['city'],
      json['governorate'],
      json['state'],
    ].firstWhere(
      (value) => value != null && value.toString().trim().isNotEmpty,
      orElse: () => '',
    );

    final areaValue = [
      json['area'],
      json['district'],
      json['neighborhood'],
    ].firstWhere(
      (value) => value != null && value.toString().trim().isNotEmpty,
      orElse: () => '',
    );

    return AddressDto(
      id: json['id']?.toString() ?? '',
      recipientName: recipientNameValue.toString(),
      phone: phoneValue.toString(),
      addressLine: addressLineValue.toString(),
      city: cityValue.toString(),
      area: areaValue.toString(),
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
      label: json['label']?.toString() ?? 'Home',
      servingStoreId: json['servingStoreId']?.toString() ?? '',
      isServiceable: json['isServiceable'] as bool? ?? false,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAtUtc: json['createdAtUtc'] == null
          ? null
          : DateTime.tryParse(json['createdAtUtc'].toString()),
      lastUsedAtUtc: json['lastUsedAtUtc'] == null
          ? null
          : DateTime.tryParse(json['lastUsedAtUtc'].toString()),
    );
  }

  Map<String, dynamic> toJson() => _$AddressDtoToJson(this);

  AddressEntity toDomain() {
    final resolvedAddress = [
      addressLine,
      '',
    ].firstWhere(
      (value) => value.trim().isNotEmpty,
      orElse: () => '',
    );

    return AddressEntity(
      id: id,
      address: resolvedAddress.isNotEmpty ? resolvedAddress : city,
      phoneNumber: phone,
      recipientName: recipientName,
      city: city,
      area: area,
      label: label,
      isDefault: isDefault,
    );
  }
}