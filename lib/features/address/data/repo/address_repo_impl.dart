import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/services/geocoding_service.dart';
import 'package:flower_app/core/services/location_service.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressRepo)
class AddressRepoImpl implements AddressRepo {
  final LocationService _locationService;
  final GeocodingService _geocodingService;

  AddressRepoImpl(this._locationService, this._geocodingService);

  @override
  Future<BaseResponse<bool>> isLocationServiceEnabled() async {
    try {
      final isEnabled = await _locationService.isLocationServiceEnabled();

      return SuccessResponse(isEnabled);
    } catch (e) {
      return ErrorResponse(
        appError: BadResponseError(AppString.couldNotGetLocation),
      );
    }
  }

  @override
  Future<BaseResponse<LocationPermission>> checkLocationPermission() async {
    try {
      final permission = await _locationService.checkPermission();

      return SuccessResponse(permission);
    } catch (e) {
      return ErrorResponse(
        appError: BadResponseError(AppString.couldNotGetLocation),
      );
    }
  }

  @override
  Future<BaseResponse<LocationPermission>> requestLocationPermission() async {
    try {
      final permission = await _locationService.requestPermission();

      return SuccessResponse(permission);
    } catch (e) {
      return ErrorResponse(
        appError: BadResponseError(AppString.couldNotGetLocation),
      );
    }
  }

  @override
  Future<BaseResponse<bool>> openLocationSettings() async {
    try {
      final result = await _locationService.openLocationSettings();

      return SuccessResponse(result);
    } catch (e) {
      return ErrorResponse(
        appError: BadResponseError(AppString.couldNotGetLocation),
      );
    }
  }

  @override
  Future<BaseResponse<bool>> openAppSettings() async {
    try {
      final result = await _locationService.openAppSettings();

      return SuccessResponse(result);
    } catch (e) {
      return ErrorResponse(
        appError: BadResponseError(AppString.couldNotGetLocation),
      );
    }
  }

  @override
  Future<BaseResponse<LocationEntity>> getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();

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
