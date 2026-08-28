
import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';

@injectable
class GeocodingService {
  Future<Placemark?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final geocoding = Geocoding();

      final placemarks = await geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isEmpty) {
        return null;
      }

      return placemarks.first;
    } catch (e) {
      return null;
    }
  }
}
