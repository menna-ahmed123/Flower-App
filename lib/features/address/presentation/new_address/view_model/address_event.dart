import 'package:flower_app/features/address/domain/entities/address_entity.dart';

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
