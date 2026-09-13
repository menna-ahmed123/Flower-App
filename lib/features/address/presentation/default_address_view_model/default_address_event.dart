sealed class DefaultAddressEvent {
  const DefaultAddressEvent();
}

class LoadSavedAddresses extends DefaultAddressEvent {
  const LoadSavedAddresses();
}

class DeleteSavedAddress extends DefaultAddressEvent {
  final String id;

  const DeleteSavedAddress(this.id);
}

class SetDefaultAddress extends DefaultAddressEvent {
  final String id;

  const SetDefaultAddress(this.id);
}
