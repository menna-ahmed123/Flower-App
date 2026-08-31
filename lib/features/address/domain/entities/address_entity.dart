import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String? address;
  final String? phoneNumber;
  final String? recipientName;
  final String? city;
  final String? area;

  const AddressEntity({
    this.address,
    this.phoneNumber,
    this.recipientName,
    this.city,
    this.area,
  });

  @override
  List<Object?> get props => [address, phoneNumber, recipientName, city, area];
}
