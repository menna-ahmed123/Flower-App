import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_details_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_address_details_use_case_test.mocks.dart';

@GenerateMocks([AddressRepo])
void main() {
  late AddressRepo addressRepo;
  late GetAddressDetailsUseCase getAddressDetailsUseCase;

  setUp(() {
    addressRepo = MockAddressRepo();

    getAddressDetailsUseCase = GetAddressDetailsUseCase(
      repo: addressRepo,
    );
  });

  const String addressId = '1';

  const addressEntity = AddressEntity(
    id: '1',
    recipientName: 'Menna Ahmed',
    phoneNumber: '01012345678',
    city: 'Cairo',
    area: 'Nasr City',
    address: 'Street 10, Building 5',
    label: 'Home',
  );

  const String dummyErrorMessage = 'Dummy Message';

  group('test get address details use case states', () {
    test(
      'test get address details use case success state',
      () async {
        // Arrange
        when(
          addressRepo.addressDetails(addressId),
        ).thenAnswer(
          (_) async => const SuccessResponse<AddressEntity>(
            addressEntity,
          ),
        );

        // Act
        final result = await getAddressDetailsUseCase.addressDetails(
          addressId,
        );

        // Assert
        expect(
          result,
          isA<SuccessResponse<AddressEntity>>(),
        );

        final successResponse =
            result as SuccessResponse<AddressEntity>;

        expect(successResponse.data, addressEntity);

        verify(
          addressRepo.addressDetails(addressId),
        ).called(1);
      },
    );

    test(
      'test get address details use case error state',
      () async {
        // Arrange
        final error = BadResponseError(dummyErrorMessage);

        when(
          addressRepo.addressDetails(addressId),
        ).thenAnswer(
          (_) async => ErrorResponse<AddressEntity>(
            appError: error,
          ),
        );

        // Act
        final result = await getAddressDetailsUseCase.addressDetails(
          addressId,
        );

        // Assert
        expect(
          result,
          isA<ErrorResponse<AddressEntity>>(),
        );

        final errorResponse =
            result as ErrorResponse<AddressEntity>;

        expect(
          errorResponse.errorMessage,
          dummyErrorMessage,
        );

        verify(
          addressRepo.addressDetails(addressId),
        ).called(1);
      },
    );
  });
}