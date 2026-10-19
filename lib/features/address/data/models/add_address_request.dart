import 'package:json_annotation/json_annotation.dart';

part 'add_address_request.g.dart';

@JsonSerializable()
class AddAddressRequest {
  final String recipientName;
  final String recipientPhone;
  final String addressLine;
  final int governorateId;
  final int cityId;
  final String area;
  final double? lat;
  final double? lng;
  final String label;

  AddAddressRequest({
    required this.recipientName,
    required this.recipientPhone,
    required this.addressLine,
    required this.governorateId,
    required this.cityId,
    required this.area,
    this.lat,
    this.lng,
    required this.label,
  });

  factory AddAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$AddAddressRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddAddressRequestToJson(this);
}