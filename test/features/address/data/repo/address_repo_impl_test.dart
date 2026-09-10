import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/core/services/geocoding_service.dart';
import 'package:flower_app/core/services/location_service.dart';
import 'package:flower_app/features/address/data/data_sources/address_remote_data_source.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/data/models/add_address_response.dart';
import 'package:flower_app/features/address/data/models/address_dto.dart';
import 'package:flower_app/features/address/data/repo/address_repo_impl.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_repo_impl_test.mocks.dart';

@GenerateMocks([LocationService, GeocodingService, AddressRemoteDataSource])
void main() {
  provideDummy<AddressResponse>(
    AddressResponse(
      success: true,
      statusCode: 200,
      message: 'Success',
      messageLocalized: 'Success',
      data: const [],
    ),
  );

  late MockLocationService locationService;
  late MockGeocodingService geocodingService;
  late MockAddressRemoteDataSource remoteDataSource;
  late AddressRepoImpl repo;

  final request = AddAddressRequest(
    recipientName: 'Joudy',
    phone: '01000000000',
    addressLine: '12 Nile St',
    city: 'Cairo',
    area: 'Dokki',
    label: 'Home',
  );

  final addressDto = AddressDto(
    id: 'addr-1',
    recipientName: 'Joudy',
    phone: '01000000000',
    addressLine: '12 Nile St',
    city: 'Cairo',
    area: 'Dokki',
    lat: 30.0,
    lng: 31.0,
    label: 'Home',
    servingStoreId: 'store-1',
    isServiceable: true,
    isDefault: true,
  );

  AddressResponse successResponse() {
    return AddressResponse(
      success: true,
      statusCode: 200,
      message: 'Success',
      messageLocalized: 'Success',
      data: [addressDto],
    );
  }

  setUp(() {
    locationService = MockLocationService();
    geocodingService = MockGeocodingService();
    remoteDataSource = MockAddressRemoteDataSource();
    repo = AddressRepoImpl(
      locationService,
      geocodingService,
      SafeCall(),
      remoteDataSource,
    );
  });

  group('getAddresses', () {
    test('returns SuccessResponse when data source succeeds', () async {
      when(remoteDataSource.getAddresses()).thenAnswer(
        (_) async => successResponse(),
      );

      final result = await repo.getAddresses();

      expect(result, isA<SuccessResponse<List<AddressEntity>>>());
      final data = (result as SuccessResponse<List<AddressEntity>>).data;
      expect(data, hasLength(1));
      expect(data.first.id, 'addr-1');
      expect(data.first.address, '12 Nile St');
      expect(data.first.city, 'Cairo');
      expect(data.first.latitude, 30.0);
      expect(data.first.longitude, 31.0);
      verify(remoteDataSource.getAddresses()).called(1);
    });

    test('returns ErrorResponse when data source fails', () async {
      when(remoteDataSource.getAddresses()).thenThrow(
        ApiException(message: 'Get addresses failed'),
      );

      final result = await repo.getAddresses();

      expect(result, isA<ErrorResponse<List<AddressEntity>>>());
      expect(
        (result as ErrorResponse<List<AddressEntity>>).errorMessage,
        'Get addresses failed',
      );
      verify(remoteDataSource.getAddresses()).called(1);
    });
  });

  group('createAddress', () {
    test('returns SuccessResponse when data source succeeds', () async {
      when(remoteDataSource.createAddress(request)).thenAnswer(
        (_) async => successResponse(),
      );

      final result = await repo.createAddress(request);

      expect(result, isA<SuccessResponse<AddressEntity>>());
      final data = (result as SuccessResponse<AddressEntity>).data;
      expect(data.recipientName, 'Joudy');
      expect(data.label, 'Home');
      verify(remoteDataSource.createAddress(request)).called(1);
    });

    test('accepts a 201 success payload with a single address object', () async {
      final payload = {
        'success': true,
        'statusCode': 201,
        'message': 'Address created successfully.',
        'messageLocalized': 'Address created successfully.',
        'data': {
          'id': 'addr-1',
          'recipientName': 'Joudy',
          'phone': '01000000000',
          'addressLine': '12 Nile St',
          'city': 'Cairo',
          'area': 'Dokki',
          'label': 'Home',
        },
      };

      when(remoteDataSource.createAddress(request)).thenAnswer(
        (_) async => AddressResponse.fromJson(payload),
      );

      final result = await repo.createAddress(request);

      expect(result, isA<SuccessResponse<AddressEntity>>());
      final data = (result as SuccessResponse<AddressEntity>).data;
      expect(data.id, 'addr-1');
      expect(data.address, '12 Nile St');
      expect(data.city, 'Cairo');
      expect(data.area, 'Dokki');
      verify(remoteDataSource.createAddress(request)).called(1);
    });

    test('returns ErrorResponse when data source fails', () async {
      when(remoteDataSource.createAddress(request)).thenThrow(
        ApiException(message: 'Add address failed'),
      );

      final result = await repo.createAddress(request);

      expect(result, isA<ErrorResponse<AddressEntity>>());
      expect(
        (result as ErrorResponse<AddressEntity>).errorMessage,
        'Add address failed',
      );
      verify(remoteDataSource.createAddress(request)).called(1);
    });
  });

  group('addressDetails', () {
    const addressId = 'addr-1';

    test('returns SuccessResponse with first address when data source succeeds', () async {
      when(remoteDataSource.addressDetails(addressId)).thenAnswer(
        (_) async => successResponse(),
      );

      final result = await repo.addressDetails(addressId);

      expect(result, isA<SuccessResponse<AddressEntity>>());
      expect((result as SuccessResponse<AddressEntity>).data.id, 'addr-1');
      verify(remoteDataSource.addressDetails(addressId)).called(1);
    });

    test('returns ErrorResponse when data source fails', () async {
      when(remoteDataSource.addressDetails(addressId)).thenThrow(
        ApiException(message: 'Get address details failed'),
      );

      final result = await repo.addressDetails(addressId);

      expect(result, isA<ErrorResponse<AddressEntity>>());
      expect(
        (result as ErrorResponse<AddressEntity>).errorMessage,
        'Get address details failed',
      );
      verify(remoteDataSource.addressDetails(addressId)).called(1);
    });
  });

  group('updateAddress', () {
    const addressId = 'addr-1';

    test('returns SuccessResponse when data source succeeds', () async {
      when(remoteDataSource.updateAddress(addressId, request)).thenAnswer(
        (_) async => successResponse(),
      );

      final result = await repo.updateAddress(addressId, request);

      expect(result, isA<SuccessResponse<List<AddressEntity>>>());
      expect((result as SuccessResponse<List<AddressEntity>>).data, isNotEmpty);
      expect((result).data.first.id, 'addr-1');
      verify(remoteDataSource.updateAddress(addressId, request)).called(1);
    });

    test('returns ErrorResponse when data source fails', () async {
      when(remoteDataSource.updateAddress(addressId, request)).thenThrow(
        ApiException(message: 'Update address failed'),
      );

      final result = await repo.updateAddress(addressId, request);

      expect(result, isA<ErrorResponse<List<AddressEntity>>>());
      expect(
        (result as ErrorResponse<List<AddressEntity>>).errorMessage,
        'Update address failed',
      );
      verify(remoteDataSource.updateAddress(addressId, request)).called(1);
    });
  });

  group('deleteAddress', () {
    const addressId = 'addr-1';

    test('returns SuccessResponse when data source succeeds', () async {
      when(remoteDataSource.deleteAddress(addressId)).thenAnswer((_) async {});

      final result = await repo.deleteAddress(addressId);

      expect(result, isA<SuccessResponse<bool>>());
      expect((result as SuccessResponse<bool>).data, isTrue);
      verify(remoteDataSource.deleteAddress(addressId)).called(1);
    });

    test('returns ErrorResponse when data source fails', () async {
      when(remoteDataSource.deleteAddress(addressId)).thenThrow(
        ApiException(message: 'Delete address failed'),
      );

      final result = await repo.deleteAddress(addressId);

      expect(result, isA<ErrorResponse<bool>>());
      expect(
        (result as ErrorResponse<bool>).errorMessage,
        'Delete address failed',
      );
      verify(remoteDataSource.deleteAddress(addressId)).called(1);
    });
  });
   group('getCurrentLocation', () {
    test('should return location successfully', () async {
      // Arrange
      final position = Position(
        latitude: 27.18,
        longitude: 31.18,
        timestamp: DateTime.now(),
        accuracy: 10,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );

      when(
        locationService.getCurrentPosition(),
      ).thenAnswer((_) async => position);

      // Act
      final result = await repo.getCurrentLocation();

      // Assert
      expect(result, isA<SuccessResponse<LocationEntity>>());

      final successResult = result as SuccessResponse<LocationEntity>;

      expect(successResult.data.latitude, position.latitude);

      expect(successResult.data.longitude, position.longitude);

      verify(locationService.getCurrentPosition()).called(1);
    });

    test(
      'should return error when getting position throws exception',
      () async {
        // Arrange
        when(locationService.getCurrentPosition()).thenThrow(Exception());

        // Act
        final result = await repo.getCurrentLocation();

        // Assert
        expect(result, isA<ErrorResponse<LocationEntity>>());

        final errorResult = result as ErrorResponse<LocationEntity>;

        expect(errorResult.appError, isA<BadResponseError>());

        expect(errorResult.errorMessage, AppString.couldNotGetLocation);

        verify(locationService.getCurrentPosition()).called(1);
      },
    );
  });

  // ============================================================
  // getAddressFromLocation
  // ============================================================

  group('getAddressFromLocation', () {
    test('should return address successfully', () async {
      // Arrange
      const latitude = 27.18;
      const longitude = 31.18;

      final placemark = Placemark(
        street: '123 Street',
        locality: 'Sohag',
        subLocality: 'Sohag',
      );

      when(
        geocodingService.getAddressFromCoordinates(
          latitude: latitude,
          longitude: longitude,
        ),
      ).thenAnswer((_) async => placemark);

      // Act
      final result = await repo.getAddressFromLocation(
        latitude: latitude,
        longitude: longitude,
      );

      // Assert
      expect(result, isA<SuccessResponse<AddressEntity>>());

      final successResult = result as SuccessResponse<AddressEntity>;

      expect(successResult.data.address, placemark.street);

      expect(successResult.data.city, placemark.locality);

      expect(successResult.data.area, placemark.subLocality);

      expect(successResult.data.latitude, latitude);

      expect(successResult.data.longitude, longitude);

      verify(
        geocodingService.getAddressFromCoordinates(
          latitude: latitude,
          longitude: longitude,
        ),
      ).called(1);
    });

    test('should return error when placemark is null', () async {
      // Arrange
      const latitude = 27.18;
      const longitude = 31.18;

      when(
        geocodingService.getAddressFromCoordinates(
          latitude: latitude,
          longitude: longitude,
        ),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repo.getAddressFromLocation(
        latitude: latitude,
        longitude: longitude,
      );

      // Assert
      expect(result, isA<ErrorResponse<AddressEntity>>());

      final errorResult = result as ErrorResponse<AddressEntity>;

      expect(errorResult.appError, isA<BadResponseError>());

      expect(errorResult.errorMessage, AppString.couldNotGetAddress);

      verify(
        geocodingService.getAddressFromCoordinates(
          latitude: latitude,
          longitude: longitude,
        ),
      ).called(1);
    });

    test('should return error when geocoding throws exception', () async {
      // Arrange
      const latitude = 27.18;
      const longitude = 31.18;

      when(
        geocodingService.getAddressFromCoordinates(
          latitude: latitude,
          longitude: longitude,
        ),
      ).thenThrow(Exception());

      // Act
      final result = await repo.getAddressFromLocation(
        latitude: latitude,
        longitude: longitude,
      );

      // Assert
      expect(result, isA<ErrorResponse<AddressEntity>>());

      final errorResult = result as ErrorResponse<AddressEntity>;

      expect(errorResult.appError, isA<BadResponseError>());

      expect(errorResult.errorMessage, AppString.couldNotGetAddress);

      verify(
        geocodingService.getAddressFromCoordinates(
          latitude: latitude,
          longitude: longitude,
        ),
      ).called(1);
    });
  });
}


