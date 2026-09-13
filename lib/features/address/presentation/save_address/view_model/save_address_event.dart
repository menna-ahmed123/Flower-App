
import 'package:flower_app/features/address/domain/entities/address_entity.dart';

sealed class SaveAddressEvent {}
class AddAddress extends SaveAddressEvent {
  final AddressEntity address;

  AddAddress(this.address);
}

class EditAddress extends SaveAddressEvent {
  final AddressEntity address;

  EditAddress(this.address);
}