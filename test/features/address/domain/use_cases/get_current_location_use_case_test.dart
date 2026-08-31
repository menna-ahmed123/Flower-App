import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:flower_app/features/address/domain/use_cases/get_current_location_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_current_location_use_case_test.mocks.dart';

@GenerateMocks([AddressRepo])
void main() {
  provideDummy<BaseResponse<LocationEntity>>(
    const SuccessResponse<LocationEntity>(
      LocationEntity(
        latitude: 27.18,
        longitude: 31.18,
      ),
    ),
  );

  late MockAddressRepo addressRepo;
  late GetCurrentLocationUseCase getCurrentLocationUseCase;

  setUp(() {
    addressRepo = MockAddressRepo();

    getCurrentLocationUseCase =
        GetCurrentLocationUseCase(addressRepo);
  });

  group('GetCurrentLocationUseCase', () {
    test('should return current location successfully', () async {
      // Arrange
      const location = LocationEntity(
        latitude: 27.18,
        longitude: 31.18,
      );

      final response = SuccessResponse<LocationEntity>(location);

      when(
        addressRepo.getCurrentLocation(),
      ).thenAnswer(
        (_) async => response,
      );

      // Act
      final result = await getCurrentLocationUseCase();

      // Assert
      expect(result, response);

      verify(
        addressRepo.getCurrentLocation(),
      ).called(1);
    });

    test(
      'should return error when getting current location fails',
      () async {
        // Arrange
        final appError = NoInternetError(Exception());

        final response = ErrorResponse<LocationEntity>(
          appError: appError,
        );

        when(
          addressRepo.getCurrentLocation(),
        ).thenAnswer(
          (_) async => response,
        );

        // Act
        final result = await getCurrentLocationUseCase();

        // Assert
        expect(result, response);

        verify(
          addressRepo.getCurrentLocation(),
        ).called(1);
      },
    );
  });
}
