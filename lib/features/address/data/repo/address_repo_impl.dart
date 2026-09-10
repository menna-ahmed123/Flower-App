import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/core/services/geocoding_service.dart';
import 'package:flower_app/core/services/location_service.dart';
import 'package:flower_app/features/address/data/data_sources/address_remote_data_source.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressRepo)
class AddressRepoImpl implements AddressRepo {
  final LocationService _locationService;
  final GeocodingService _geocodingService;
  final SafeCall safeCall;
  final AddressRemoteDataSource remoteDataSource;

   AddressRepoImpl(
    this._locationService,
    this._geocodingService,
    this.safeCall,
    this.remoteDataSource,
  );

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
        latitude: latitude,
        longitude: longitude,
      );

      return SuccessResponse(address);
    } catch (e) {
      return ErrorResponse(
        appError: BadResponseError(AppString.couldNotGetAddress),
      );
    }
  }

  @override
  Future<BaseResponse<List<AddressEntity>>> getAddresses() {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.getAddresses();
      return response.toDomain();
    });
  }

  @override
  Future<BaseResponse<AddressEntity>> createAddress(
    AddAddressRequest request,
  ) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.createAddress(request);

      if (response.success == false) {
        throw ApiException(
          message: (response.message).isNotEmpty
              ? response.message
              : AppString.somethingWrong,
          statusCode: response.statusCode,
        );
      }

      final created = response.toDomain();

      if (created.isNotEmpty) {
        return created.first;
      }

      return AddressEntity(
        address: request.addressLine,
        phoneNumber: request.phone,
        recipientName: request.recipientName,
        city: request.city,
        area: request.area,
        label: request.label,
      );
    });
  }

  @override
  Future<BaseResponse<bool>> deleteAddress(String id) {
    return safeCall.safeApiCall(() async {
      await remoteDataSource.deleteAddress(id);
      return true;
    });
  }

  @override
  Future<BaseResponse<AddressEntity>> addressDetails(String id) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.addressDetails(id);
      final addresses = response.toDomain();
      if (addresses.isEmpty) {
        throw ApiException(message: AppString.couldNotGetAddress);
      }
      return addresses.first;
    });
  }

  @override
  Future<BaseResponse<List<AddressEntity>>> updateAddress(
    String id,
    AddAddressRequest request,
  ) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.updateAddress(id, request);
      return response.toDomain();
    });
  }
  @override
  Future<BaseResponse<AddressEntity>> setDefaultAddress(String addressId) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.setDefaultAddress(addressId);
      final addresses = response.toDomain();
      if (addresses.isEmpty) {
        throw ApiException(message: AppString.couldNotGetAddress);
      }
      return addresses.first;
    });
  }
}
