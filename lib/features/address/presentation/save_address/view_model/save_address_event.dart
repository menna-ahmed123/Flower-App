import 'package:flower_app/features/address/domain/entities/address_entity.dart';

sealed class SaveAddressEvent {}

class LoadSavedAddresses extends SaveAddressEvent {}

// class AddSavedAddress extends SaveAddressEvent {
//   final AddressEntity address;

//   AddSavedAddress(this.address);
// }

class DeleteSavedAddress extends SaveAddressEvent {
  final String id;

  DeleteSavedAddress(this.id);
}

// class EditSavedAddress extends SaveAddressEvent {
//   final AddressEntity address;

//   EditSavedAddress(this.address);
// }
