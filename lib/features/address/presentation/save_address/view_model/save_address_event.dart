import 'package:flower_app/features/address/domain/entities/address_entity.dart';

sealed class SaveAddressEvent {
  const SaveAddressEvent();
}

class AddAddress extends SaveAddressEvent {
  final AddressEntity address;

  const AddAddress(this.address);
}

class EditAddress extends SaveAddressEvent {
  final AddressEntity address;

  const EditAddress(this.address);
}
