import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:flower_app/features/address/domain/use_cases/get_update_address_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_update_address_use_case_test.mocks.dart';

@GenerateMocks([AddressRepo])
void main() {
  late AddressRepo addressRepo;
  late GetUpdateAddressUseCase getUpdateAddressUseCase;

  setUp(() {
    addressRepo = MockAddressRepo();

    getUpdateAddressUseCase = GetUpdateAddressUseCase(
      repo: addressRepo,
    );
  });

  const String addressId = '1';

  final request = AddAddressRequest(
    recipientName: 'Menna Ahmed',
    phone: '01012345678',
    city: 'Cairo',
    area: 'Nasr City',
    addressLine: 'Street 10, Building 5',
    label: 'Home',
  );

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

  group('test update address use case states', () {
    test(
      'test update address use case success state',
      () async {
        // Arrange
        when(
          addressRepo.updateAddress(
            addressId,
            request,
          ),
        ).thenAnswer(
          (_) async => const SuccessResponse<List<AddressEntity>>(
            [addressEntity],
          ),
        );

        // Act
        final result = await getUpdateAddressUseCase.updateAddress(
          addressId,
          request,
        );

        // Assert
        expect(
          result,
          isA<SuccessResponse<List<AddressEntity>>>(),
        );

        final successResponse =
            result as SuccessResponse<List<AddressEntity>>;

        expect(
          successResponse.data,
          [addressEntity],
        );

        verify(
          addressRepo.updateAddress(
            addressId,
            request,
          ),
        ).called(1);
      },
    );

    test(
      'test update address use case error state',
      () async {
        // Arrange
        final error = BadResponseError(dummyErrorMessage);

        when(
          addressRepo.updateAddress(
            addressId,
            request,
          ),
        ).thenAnswer(
          (_) async => ErrorResponse<List<AddressEntity>>(
            appError: error,
          ),
        );

        // Act
        final result = await getUpdateAddressUseCase.updateAddress(
          addressId,
          request,
        );

        // Assert
        expect(
          result,
          isA<ErrorResponse<List<AddressEntity>>>(),
        );

        final errorResponse =
            result as ErrorResponse<List<AddressEntity>>;

        expect(
          errorResponse.errorMessage,
          dummyErrorMessage,
        );

        verify(
          addressRepo.updateAddress(
            addressId,
            request,
          ),
        ).called(1);
      },
    );
  });
}