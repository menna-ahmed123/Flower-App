import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_address_details_use_case_test.mocks.dart';

@GenerateMocks([AddressRepo])
void main() {
  late AddressRepo addressRepo;
  late GetAddressUseCase getAddressUseCase;

  setUpAll(() {
    addressRepo = MockAddressRepo();
    getAddressUseCase = GetAddressUseCase(repo:addressRepo );
  });

  const addressList = [
    AddressEntity(
      id: '1',
      recipientName: 'Menna Ahmed',
      phoneNumber: '01012345678',
      city: 'Cairo',
      area: 'Nasr City',
      address: 'Street 10, Building 5',
      label: 'Home',
    ),
  ];
  const String dummyErrorMessage = "Dummy Message";

  group("test get address use case states", () {
    test("test get address use case success state", () async {
      // Arrange
      provideDummy<BaseResponse<List<AddressEntity>>>(
        const SuccessResponse(addressList),
      );
      when(
        addressRepo.getAddresses(),
      ).thenAnswer((_) async => const SuccessResponse<List<AddressEntity>>(addressList));

      // Act
      final result = await getAddressUseCase.getAddresses();

      // Assert
      expect(result, isA<SuccessResponse<List<AddressEntity>>>());
      final successResponse = result as SuccessResponse<List<AddressEntity>>;
      expect(successResponse.data, addressList);
    });

    test("test get address use case error state", () async {
      // Arrange
      final error = BadResponseError(dummyErrorMessage);

      provideDummy<BaseResponse<List<AddressEntity>>>(
        ErrorResponse(appError: error),
      );
      when(
        addressRepo.getAddresses(),
      ).thenAnswer((_) async => ErrorResponse(appError: error));

      // Act
      final result = await getAddressUseCase.getAddresses();

      // Assert
      expect(result, isA<ErrorResponse<List<AddressEntity>>>());
      final errorResponse = result as ErrorResponse<List<AddressEntity>>;
      expect(errorResponse.errorMessage, dummyErrorMessage);
    });
  });
}