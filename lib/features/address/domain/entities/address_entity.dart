import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String? address;
  final String? phoneNumber;
  final String? recipientName;
  final String? city;
  final String? area;
    final String? id;
  final String? label;


  const AddressEntity({
    this.address,
    this.phoneNumber,
    this.recipientName,
    this.city,
    this.area, this.id, this.label,
  });

  @override
  List<Object?> get props => [address, phoneNumber, recipientName, city, area,id,label];
}
