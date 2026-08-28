import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
@injectable
class LocationService {
  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  Future<bool> openAppSettings() async {
    return Geolocator.openAppSettings();
  }

  Future<bool> openLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  Future<Position?> getCurrentPosition() async {
    final isEnabled = await isLocationServiceEnabled();

    if (!isEnabled) {
      await openLocationSettings();
      return null;
    }

    var permission = await checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      await openAppSettings();
      return null;
    }

    if (permission == LocationPermission.denied) {
      return null;
    }

    return Geolocator.getCurrentPosition();
  }
}
