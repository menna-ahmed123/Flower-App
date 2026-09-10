
import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String? address;
  final String? phoneNumber;
  final String? recipientName;
  final String? city;
  final String? area;
  final String? id;
  final String? label;
  final bool isDefault;
  final double? latitude;
  final double? longitude;


  const AddressEntity({
    this.address,
    this.phoneNumber,
    this.recipientName,
    this.city,
    this.area,
    this.id,
    this.label,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  AddressEntity copyWith({
    String? address,
    String? phoneNumber,
    String? recipientName,
    String? city,
    String? area,
    String? id,
    String? label,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return AddressEntity(
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      recipientName: recipientName ?? this.recipientName,
      city: city ?? this.city,
      area: area ?? this.area,
      id: id ?? this.id,
      label: label ?? this.label,
      isDefault: isDefault ?? this.isDefault,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [
        address,
        phoneNumber,
        recipientName,
        city,
        area,
        id,
        label,
        isDefault,
         latitude,
    longitude
      ];
}

