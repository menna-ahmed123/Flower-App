
sealed class AddressEvent {}
class GetCurrentAddress extends AddressEvent {}
class LoadAddressDetails extends AddressEvent {
  final String id;
  LoadAddressDetails(this.id);
}
class LocationSelected extends AddressEvent {
  final double latitude;
  final double longitude;
  LocationSelected({
    required this.latitude,
    required this.longitude,
  });
}