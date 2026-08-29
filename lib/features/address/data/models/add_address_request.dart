import 'package:json_annotation/json_annotation.dart';

part 'add_address_request.g.dart';

@JsonSerializable()
class AddAddressRequest {
  final String recipientName;
  final String phone;
  final String addressLine;
  final String city;
  final String area;
  final String label;

  AddAddressRequest({
    required this.recipientName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.area,
    required this.label,
  });

  factory AddAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$AddAddressRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddAddressRequestToJson(this);
}