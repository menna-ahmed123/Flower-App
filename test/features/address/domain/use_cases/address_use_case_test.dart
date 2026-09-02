import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:flower_app/features/address/domain/use_cases/address_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_use_case_test.mocks.dart';

@GenerateMocks([AddressRepo])
void main() {
  provideDummy<BaseResponse<List<AddressEntity>>>(
    const SuccessResponse<List<AddressEntity>>([]),
  );
  provideDummy<BaseResponse<AddressEntity>>(
    const SuccessResponse<AddressEntity>(AddressEntity()),
  );
  provideDummy<BaseResponse<bool>>(const SuccessResponse<bool>(true));

  late MockAddressRepo addressRepo;
  late GetAddressUseCase useCase;

  const addresses = [
    AddressEntity(
      id: 'addr-1',
      address: '12 Nile St',
      phoneNumber: '01000000000',
      recipientName: 'Joudy',
      city: 'Cairo',
      area: 'Dokki',
      label: 'Home',
    ),
  ];

  final request = AddAddressRequest(
    recipientName: 'Joudy',
    phone: '01000000000',
    addressLine: '12 Nile St',
    city: 'Cairo',
    area: 'Dokki',
    label: 'Home',
  );

  setUp(() {
    addressRepo = MockAddressRepo();
    useCase = GetAddressUseCase(repo: addressRepo);
  });

  group('getAddresses', () {
    test('returns SuccessResponse when repo call succeeds', () async {
      when(addressRepo.getAddresses()).thenAnswer(
        (_) async => const SuccessResponse(addresses),
      );

      final result = await useCase.getAddresses();

      expect(result, isA<SuccessResponse<List<AddressEntity>>>());
      expect(
        (result as SuccessResponse<List<AddressEntity>>).data,
        addresses,
      );
      verify(addressRepo.getAddresses()).called(1);
    });

    test('returns ErrorResponse when repo call fails', () async {
      when(addressRepo.getAddresses()).thenAnswer(
        (_) async => ErrorResponse<List<AddressEntity>>(
          appError: BadResponseError('Get addresses failed'),
        ),
      );

      final result = await useCase.getAddresses();

      expect(result, isA<ErrorResponse<List<AddressEntity>>>());
      expect(
        (result as ErrorResponse<List<AddressEntity>>).errorMessage,
        'Get addresses failed',
      );
      verify(addressRepo.getAddresses()).called(1);
    });
  });

  group('addAddress', () {
    test('returns SuccessResponse when repo call succeeds', () async {
      when(addressRepo.createAddress(request)).thenAnswer(
        (_) async => const SuccessResponse(addresses),
      );

      final result = await useCase.addAddress(request);

      expect(result, isA<SuccessResponse<List<AddressEntity>>>());
      expect(
        (result as SuccessResponse<List<AddressEntity>>).data.first.id,
        'addr-1',
      );
      verify(addressRepo.createAddress(request)).called(1);
    });

    test('returns ErrorResponse when repo call fails', () async {
      when(addressRepo.createAddress(request)).thenAnswer(
        (_) async => ErrorResponse<List<AddressEntity>>(
          appError: BadResponseError('Add address failed'),
        ),
      );

      final result = await useCase.addAddress(request);

      expect(result, isA<ErrorResponse<List<AddressEntity>>>());
      expect(
        (result as ErrorResponse<List<AddressEntity>>).errorMessage,
        'Add address failed',
      );
      verify(addressRepo.createAddress(request)).called(1);
    });
  });

  group('addressDetails', () {
    const addressId = 'addr-1';

    test('returns SuccessResponse when repo call succeeds', () async {
      when(addressRepo.addressDetails(addressId)).thenAnswer(
        (_) async => SuccessResponse(addresses.first),
      );

      final result = await useCase.addressDetails(addressId);

      expect(result, isA<SuccessResponse<AddressEntity>>());
      expect((result as SuccessResponse<AddressEntity>).data.id, 'addr-1');
      verify(addressRepo.addressDetails(addressId)).called(1);
    });

    test('returns ErrorResponse when repo call fails', () async {
      when(addressRepo.addressDetails(addressId)).thenAnswer(
        (_) async => ErrorResponse<AddressEntity>(
          appError: BadResponseError('Get address details failed'),
        ),
      );

      final result = await useCase.addressDetails(addressId);

      expect(result, isA<ErrorResponse<AddressEntity>>());
      expect(
        (result as ErrorResponse<AddressEntity>).errorMessage,
        'Get address details failed',
      );
      verify(addressRepo.addressDetails(addressId)).called(1);
    });
  });

  group('updateAddress', () {
    const addressId = 'addr-1';

    test('returns SuccessResponse when repo call succeeds', () async {
      when(addressRepo.updateAddress(addressId, request)).thenAnswer(
        (_) async => const SuccessResponse(addresses),
      );

      final result = await useCase.updateAddress(addressId, request);

      expect(result, isA<SuccessResponse<List<AddressEntity>>>());
      verify(addressRepo.updateAddress(addressId, request)).called(1);
    });

    test('returns ErrorResponse when repo call fails', () async {
      when(addressRepo.updateAddress(addressId, request)).thenAnswer(
        (_) async => ErrorResponse<List<AddressEntity>>(
          appError: BadResponseError('Update address failed'),
        ),
      );

      final result = await useCase.updateAddress(addressId, request);

      expect(result, isA<ErrorResponse<List<AddressEntity>>>());
      expect(
        (result as ErrorResponse<List<AddressEntity>>).errorMessage,
        'Update address failed',
      );
      verify(addressRepo.updateAddress(addressId, request)).called(1);
    });
  });

  group('deleteAddress', () {
    const addressId = 'addr-1';

    test('returns SuccessResponse when repo call succeeds', () async {
      when(addressRepo.deleteAddress(addressId)).thenAnswer(
        (_) async => const SuccessResponse(true),
      );

      final result = await useCase.deleteAddress(addressId);

      expect(result, isA<SuccessResponse<bool>>());
      expect((result as SuccessResponse<bool>).data, isTrue);
      verify(addressRepo.deleteAddress(addressId)).called(1);
    });

    test('returns ErrorResponse when repo call fails', () async {
      when(addressRepo.deleteAddress(addressId)).thenAnswer(
        (_) async => ErrorResponse<bool>(
          appError: BadResponseError('Delete address failed'),
        ),
      );

      final result = await useCase.deleteAddress(addressId);

      expect(result, isA<ErrorResponse<bool>>());
      expect(
        (result as ErrorResponse<bool>).errorMessage,
        'Delete address failed',
      );
      verify(addressRepo.deleteAddress(addressId)).called(1);
    });
  });
}
