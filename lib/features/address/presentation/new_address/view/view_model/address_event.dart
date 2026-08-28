sealed class AddressEvent {}

class GetCurrentAddress extends AddressEvent {}

class LocationSelected extends AddressEvent {
  final double latitude;
  final double longitude;

  LocationSelected({required this.latitude, required this.longitude});
}
