import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:flower_app/features/address/domain/use_cases/get_delete_address_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_delete_address_use_case_test.mocks.dart';

@GenerateMocks([AddressRepo])
void main() {
  late AddressRepo addressRepo;
  late GetDeleteAddressUseCase getDeleteAddressUseCase;

  setUp(() {
    addressRepo = MockAddressRepo();

    getDeleteAddressUseCase = GetDeleteAddressUseCase(
      repo: addressRepo,
    );
  });

  const String addressId = '1';

  const String dummyErrorMessage = 'Dummy Message';

  group('test delete address use case states', () {
    test(
      'test delete address use case success state',
      () async {
        // Arrange
        when(
          addressRepo.deleteAddress(addressId),
        ).thenAnswer(
          (_) async => const SuccessResponse<bool>(true),
        );

        // Act
        final result = await getDeleteAddressUseCase.deleteAddress(
          addressId,
        );

        // Assert
        expect(
          result,
          isA<SuccessResponse<bool>>(),
        );

        final successResponse =
            result as SuccessResponse<bool>;

        expect(successResponse.data, true);

        verify(
          addressRepo.deleteAddress(addressId),
        ).called(1);
      },
    );

    test(
      'test delete address use case error state',
      () async {
        // Arrange
        final error = BadResponseError(dummyErrorMessage);

        when(
          addressRepo.deleteAddress(addressId),
        ).thenAnswer(
          (_) async => ErrorResponse<bool>(
            appError: error,
          ),
        );

        // Act
        final result = await getDeleteAddressUseCase.deleteAddress(
          addressId,
        );

        // Assert
        expect(
          result,
          isA<ErrorResponse<bool>>(),
        );

        final errorResponse =
            result as ErrorResponse<bool>;

        expect(
          errorResponse.errorMessage,
          dummyErrorMessage,
        );

        verify(
          addressRepo.deleteAddress(addressId),
        ).called(1);
      },
    );
  });
}