
sealed class SaveAddressEvent {}
class DeleteSavedAddress extends SaveAddressEvent {
  final String id;

  DeleteSavedAddress(this.id);
}
