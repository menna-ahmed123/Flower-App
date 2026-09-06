sealed class DefaultAddressEvent {}

class LoadSavedAddresses extends DefaultAddressEvent {}
class DeleteSavedAddress extends DefaultAddressEvent {
  final String id;

  DeleteSavedAddress(this.id);
}
