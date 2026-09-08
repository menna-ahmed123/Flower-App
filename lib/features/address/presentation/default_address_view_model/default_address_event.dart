sealed class DefaultAddressEvent {}

class LoadSavedAddresses extends DefaultAddressEvent {}
class DeleteSavedAddress extends DefaultAddressEvent {
  final String id;

  DeleteSavedAddress(this.id);
}
class SetDefaultAddress extends DefaultAddressEvent {
  final String id;

  SetDefaultAddress(this.id);
}