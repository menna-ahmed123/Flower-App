import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_from_location_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_address_from_location_use_case_test.mocks.dart';

@GenerateMocks([AddressRepo])
void main() {
  provideDummy<BaseResponse<AddressEntity>>(
    const SuccessResponse<AddressEntity>(
      AddressEntity(
        address: '123 Street',
        phoneNumber: '01000000000',
        recipientName: 'Menna',
        city: 'Sohag',
        area: 'Sohag',
      ),
    ),
  );

  late MockAddressRepo addressRepo;
  late GetAddressFromLocationUseCase getAddressFromLocationUseCase;

  setUp(() {
    addressRepo = MockAddressRepo();

    getAddressFromLocationUseCase =
        GetAddressFromLocationUseCase(addressRepo);
  });

  group('GetAddressFromLocationUseCase', () {
    test('should return address successfully', () async {
      // Arrange
      const latitude = 27.18;
      const longitude = 31.18;

      const address = AddressEntity(
        address: '123 Street',
        phoneNumber: '01000000000',
        recipientName: 'Menna',
        city: 'Sohag',
        area: 'Sohag',
      );

      final response = SuccessResponse<AddressEntity>(address);

      when(
        addressRepo.getAddressFromLocation(
          latitude: latitude,
          longitude: longitude,
        ),
      ).thenAnswer(
        (_) async => response,
      );

      // Act
      final result = await getAddressFromLocationUseCase(
        latitude: latitude,
        longitude: longitude,
      );

      // Assert
      expect(result, response);

      verify(
        addressRepo.getAddressFromLocation(
          latitude: latitude,
          longitude: longitude,
        ),
      ).called(1);
    });

    test('should return error when getting address fails', () async {
      // Arrange
      const latitude = 27.18;
      const longitude = 31.18;

      final appError = NoInternetError(Exception());

      final response = ErrorResponse<AddressEntity>(
        appError: appError,
      );

      when(
        addressRepo.getAddressFromLocation(
          latitude: latitude,
          longitude: longitude,
        ),
      ).thenAnswer(
        (_) async => response,
      );

      // Act
      final result = await getAddressFromLocationUseCase(
        latitude: latitude,
        longitude: longitude,
      );

      // Assert
      expect(result, response);

      verify(
        addressRepo.getAddressFromLocation(
          latitude: latitude,
          longitude: longitude,
        ),
      ).called(1);
    });
  });
}
