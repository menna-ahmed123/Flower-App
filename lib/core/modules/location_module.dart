import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@module
abstract class LocationModule {
  @lazySingleton
  GeolocatorPlatform get geolocator => GeolocatorPlatform.instance;
}
