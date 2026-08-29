import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/services/geocoding_service.dart';
import 'package:flower_app/core/services/location_service.dart';
import 'package:flower_app/features/address/data/repo/address_repo_impl.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_repo_impl_test.mocks.dart';

@GenerateMocks([
  LocationService,
  GeocodingService,
])
void main() {
  provideDummy<BaseResponse<LocationEntity>>(
    const SuccessResponse<LocationEntity>(
      LocationEntity(
        latitude: 27.18,
        longitude: 31.18,
      ),
    ),
  );

  provideDummy<BaseResponse<AddressEntity>>(
    const SuccessResponse<AddressEntity>(
      AddressEntity(
        address: '123 Street',
        city: 'Sohag',
        area: 'Sohag',
      ),
    ),
  );

  late MockLocationService locationService;
  late MockGeocodingService geocodingService;
  late AddressRepositoryImpl addressRepository;

  setUp(() {
    locationService = MockLocationService();
    geocodingService = MockGeocodingService();

    addressRepository = AddressRepositoryImpl(
      locationService,
      geocodingService,
    );
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
      ).thenAnswer(
        (_) async => position,
      );

      // Act
      final result = await addressRepository.getCurrentLocation();

      // Assert
      expect(
        result,
        isA<SuccessResponse<LocationEntity>>(),
      );

      final successResult =
          result as SuccessResponse<LocationEntity>;

      expect(
        successResult.data.latitude,
        position.latitude,
      );

      expect(
        successResult.data.longitude,
        position.longitude,
      );

      verify(
        locationService.getCurrentPosition(),
      ).called(1);
    });

    test('should return error when position is null', () async {
      // Arrange
      when(
        locationService.getCurrentPosition(),
      ).thenAnswer(
        (_) async => null,
      );

      // Act
      final result = await addressRepository.getCurrentLocation();

      // Assert
      expect(
        result,
        isA<ErrorResponse<LocationEntity>>(),
      );

      final errorResult =
          result as ErrorResponse<LocationEntity>;

      expect(
        errorResult.appError,
        isA<BadResponseError>(),
      );

      expect(
        errorResult.errorMessage,
        AppString.couldNotGetLocation,
      );

      verify(
        locationService.getCurrentPosition(),
      ).called(1);
    });

    test(
      'should return error when getting position throws exception',
      () async {
        // Arrange
        when(
          locationService.getCurrentPosition(),
        ).thenThrow(Exception());

        // Act
        final result =
            await addressRepository.getCurrentLocation();

        // Assert
        expect(
          result,
          isA<ErrorResponse<LocationEntity>>(),
        );

        final errorResult =
            result as ErrorResponse<LocationEntity>;

        expect(
          errorResult.appError,
          isA<BadResponseError>(),
        );

        expect(
          errorResult.errorMessage,
          AppString.couldNotGetLocation,
        );

        verify(
          locationService.getCurrentPosition(),
        ).called(1);
      },
    );
  });

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
      ).thenAnswer(
        (_) async => placemark,
      );

      // Act
      final result =
          await addressRepository.getAddressFromLocation(
        latitude: latitude,
        longitude: longitude,
      );

      // Assert
      expect(
        result,
        isA<SuccessResponse<AddressEntity>>(),
      );

      final successResult =
          result as SuccessResponse<AddressEntity>;

      expect(
        successResult.data.address,
        placemark.street,
      );

      expect(
        successResult.data.city,
        placemark.locality,
      );

      expect(
        successResult.data.area,
        placemark.subLocality,
      );

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
      ).thenAnswer(
        (_) async => null,
      );

      // Act
      final result =
          await addressRepository.getAddressFromLocation(
        latitude: latitude,
        longitude: longitude,
      );

      // Assert
      expect(
        result,
        isA<ErrorResponse<AddressEntity>>(),
      );

      final errorResult =
          result as ErrorResponse<AddressEntity>;

      expect(
        errorResult.appError,
        isA<BadResponseError>(),
      );

      expect(
        errorResult.errorMessage,
        AppString.couldNotGetAddress,
      );

      verify(
        geocodingService.getAddressFromCoordinates(
          latitude: latitude,
          longitude: longitude,
        ),
      ).called(1);
    });

    test(
      'should return error when geocoding throws exception',
      () async {
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
        final result =
            await addressRepository.getAddressFromLocation(
          latitude: latitude,
          longitude: longitude,
        );

        // Assert
        expect(
          result,
          isA<ErrorResponse<AddressEntity>>(),
        );

        final errorResult =
            result as ErrorResponse<AddressEntity>;

        expect(
          errorResult.appError,
          isA<BadResponseError>(),
        );

        expect(
          errorResult.errorMessage,
          AppString.couldNotGetAddress,
        );

        verify(
          geocodingService.getAddressFromCoordinates(
            latitude: latitude,
            longitude: longitude,
          ),
        ).called(1);
      },
    );
  });
}