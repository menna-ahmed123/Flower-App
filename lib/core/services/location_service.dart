import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocationService {
  final GeolocatorPlatform geolocator;

  LocationService(this.geolocator);

  Future<bool> isLocationServiceEnabled() async {
    return geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return geolocator.requestPermission();
  }

  Future<bool> openAppSettings() async {
    return geolocator.openAppSettings();
  }

  Future<bool> openLocationSettings() async {
    return geolocator.openLocationSettings();
  }

  Future<Position> getCurrentPosition() async {
    return geolocator.getCurrentPosition();
  }
}
