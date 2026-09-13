sealed class AddressEvent {
  const AddressEvent();
}

class GetCurrentAddress extends AddressEvent {
  const GetCurrentAddress();
}

class LoadAddressDetails extends AddressEvent {
  final String id;
  const LoadAddressDetails(this.id);
}

class LocationSelected extends AddressEvent {
  final double latitude;
  final double longitude;
  const LocationSelected({
    required this.latitude,
    required this.longitude,
  });
}
