import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/services/geocoding_service.dart';
import 'package:flower_app/core/services/location_service.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressRepo)
class AddressRepositoryImpl implements AddressRepo {
  final LocationService _locationService;
  final GeocodingService _geocodingService;

  AddressRepositoryImpl(this._locationService, this._geocodingService);

  @override
  Future<BaseResponse<LocationEntity>> getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();

      if (position == null) {
        return ErrorResponse(
          appError: BadResponseError(AppString.couldNotGetLocation),
        );
      }

      final location = LocationEntity(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      return SuccessResponse(location);
    } catch (e) {
      return ErrorResponse(
        appError: BadResponseError(AppString.couldNotGetLocation),
      );
    }
  }

  @override
  Future<BaseResponse<AddressEntity>> getAddressFromLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemark = await _geocodingService.getAddressFromCoordinates(
        latitude: latitude,
        longitude: longitude,
      );

      if (placemark == null) {
        return ErrorResponse(
          appError: BadResponseError(AppString.couldNotGetAddress),
        );
      }

      final address = AddressEntity(
        address: placemark.street,
        city: placemark.locality,
        area: placemark.subLocality ?? placemark.subAdministrativeArea,
      );

      return SuccessResponse(address);
    } catch (e) {
      return ErrorResponse(
        appError: BadResponseError(AppString.couldNotGetAddress),
      );
    }
  }
}
