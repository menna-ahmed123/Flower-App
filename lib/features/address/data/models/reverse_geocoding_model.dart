import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reverse_geocoding_model.g.dart';

@JsonSerializable()
class ReverseGeocodingModel {
  final String? addressLine;
  final String? city;
  final String? area;
  final double? lat;
  final double? lng;

  const ReverseGeocodingModel({
    this.addressLine,
    this.city,
    this.area,
    this.lat,
    this.lng,
  });

  factory ReverseGeocodingModel.fromJson(Map<String, dynamic> json) =>
      _$ReverseGeocodingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReverseGeocodingModelToJson(this);

  AddressEntity toDomain() {
    return AddressEntity(
      address: addressLine,
      addressLine: addressLine,
      city: city,
      area: area,
      latitude: lat,
      longitude: lng,
    );
  }
}