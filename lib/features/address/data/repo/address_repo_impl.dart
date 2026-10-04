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
import 'package:flower_app/features/address/domain/entities/city_entity.dart';
import 'package:flower_app/features/address/domain/entities/country_entity.dart';
import 'package:flower_app/features/address/domain/entities/governorate_entity.dart';
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
    // 1. Try remote reverse geocoding API first
    try {
      final response = await remoteDataSource.reverseGeocode(
        latitude,
        longitude,
      );
      final entity = response.toDomain();
      final hasAddress = (entity.address?.isNotEmpty ?? false) ||
          (entity.addressLine?.isNotEmpty ?? false);
      final hasCity = entity.city?.isNotEmpty ?? false;
      final hasArea = entity.area?.isNotEmpty ?? false;

      if (hasAddress || hasCity || hasArea) {
        return SuccessResponse(
          entity.copyWith(
            latitude: latitude,
            longitude: longitude,
          ),
        );
      }
    } catch (_) {
      // If remote reverse geocoding fails, fallback to local geocoding service
    }

    // 2. Fallback to local GeocodingService
    try {
      final placemark = await _geocodingService.getAddressFromCoordinates(
        latitude: latitude,
        longitude: longitude,
      );

      if (placemark != null) {
        final street = placemark.street;
        final locality = placemark.locality;
        final subLocality =
            placemark.subLocality ?? placemark.subAdministrativeArea;

        final address = AddressEntity(
          address: street,
          addressLine: street,
          city: locality,
          area: subLocality,
          latitude: latitude,
          longitude: longitude,
        );

        return SuccessResponse(address);
      }
    } catch (_) {
      // Both remote and local failed
    }

    return ErrorResponse(
      appError: BadResponseError(AppString.couldNotGetAddress),
    );
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

      if (response.statusCode >= 400) {
        throw ApiException(
          message: response.message.isNotEmpty
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
        addressLine: request.addressLine,
        cityId: request.cityId,
        governorateId: request.governorateId,
        phoneNumber: request.recipientPhone,
        latitude: request.lat,
        longitude: request.lng,
        recipientName: request.recipientName,
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

  @override
  Future<BaseResponse<List<CountryEntity>>> getCountries() {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.getCountries();
      return response.toDomain();
    });
  }

  @override
  Future<BaseResponse<List<GovernorateEntity>>> getGovernorates() {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.getGovernorates();
      return response.toDomain();
    });
  }

  @override
  Future<BaseResponse<List<CityEntity>>> getCities(
    int governorateId,
  ) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.getCities(governorateId);
      return response.toDomain();
    });
  }

  @override
  Future<BaseResponse<AddressEntity>> reverseGeocode(
    double lat,
    double lng,
  ) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.reverseGeocode(lat, lng);
      return response.toDomain();
    });
  }
}
