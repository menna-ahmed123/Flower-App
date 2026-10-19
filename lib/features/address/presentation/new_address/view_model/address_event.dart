import 'package:flower_app/features/address/domain/entities/city_entity.dart';
import 'package:flower_app/features/address/domain/entities/governorate_entity.dart';

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

class LoadGovernorates extends AddressEvent {}

class SelectGovernorate extends AddressEvent {
  final GovernorateEntity? governorate;
  SelectGovernorate(this.governorate);
}

class SelectCity extends AddressEvent {
  final CityEntity? city;
  SelectCity(this.city);
}