import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:geolocator/geolocator.dart';

abstract interface class AddressRepo {
  Future<BaseResponse<bool>> isLocationServiceEnabled();

  Future<BaseResponse<LocationPermission>> checkLocationPermission();

  Future<BaseResponse<LocationPermission>> requestLocationPermission();

  Future<BaseResponse<bool>> openLocationSettings();

  Future<BaseResponse<bool>> openAppSettings();

  Future<BaseResponse<AddressEntity>> getAddressFromLocation({
    required double latitude,
    required double longitude,
  });

  Future<BaseResponse<LocationEntity>> getCurrentLocation();
}
