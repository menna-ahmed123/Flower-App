import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/address_use_case.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_event.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_state.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_address_view_model_test.mocks.dart';

@GenerateMocks([GetAddressUseCase])
void main() {
  provideDummy<BaseResponse<List<AddressEntity>>>(
    const SuccessResponse<List<AddressEntity>>([]),
  );
  provideDummy<BaseResponse<bool>>(const SuccessResponse<bool>(true));
  provideDummy<AddAddressRequest>(
    AddAddressRequest(
      recipientName: '',
      phone: '',
      addressLine: '',
      city: '',
      area: '',
      label: '',
    ),
  );

  late MockGetAddressUseCase getAddressUseCase;

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

  const newAddress = AddressEntity(
    address: '12 Nile St',
    phoneNumber: '01000000000',
    recipientName: 'Joudy',
    city: 'Cairo',
    area: 'Dokki',
    label: 'Home',
  );

  setUp(() {
    getAddressUseCase = MockGetAddressUseCase();
  });

  group('LoadSavedAddresses', () {
    blocTest<SaveAddressViewModel, SaveAddressState>(
      'emits loading then success when addresses load succeeds',
      setUp: () {
        when(getAddressUseCase.getAddresses()).thenAnswer(
          (_) async => const SuccessResponse(addresses),
        );
      },
      build: () => SaveAddressViewModel(getAddressUseCase),
      act: (viewModel) => viewModel.doEvent(LoadSavedAddresses()),
      expect: () => [
        const SaveAddressState(
          addressesState: BaseState<List<AddressEntity>>(
            isLoading: true,
            errorMessage: '',
          ),
        ),
        const SaveAddressState(
          addressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            errorMessage: '',
            data: addresses,
          ),
        ),
      ],
      verify: (_) {
        verify(getAddressUseCase.getAddresses()).called(1);
      },
    );

    blocTest<SaveAddressViewModel, SaveAddressState>(
      'emits loading then error when addresses load fails',
      setUp: () {
        when(getAddressUseCase.getAddresses()).thenAnswer(
          (_) async => ErrorResponse<List<AddressEntity>>(
            appError: BadResponseError('Get addresses failed'),
          ),
        );
      },
      build: () => SaveAddressViewModel(getAddressUseCase),
      act: (viewModel) => viewModel.doEvent(LoadSavedAddresses()),
      expect: () => [
        const SaveAddressState(
          addressesState: BaseState<List<AddressEntity>>(
            isLoading: true,
            errorMessage: '',
          ),
        ),
        const SaveAddressState(
          addressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            errorMessage: 'Get addresses failed',
          ),
        ),
      ],
      verify: (_) {
        verify(getAddressUseCase.getAddresses()).called(1);
      },
    );
  });

  group('AddSavedAddress', () {
    blocTest<SaveAddressViewModel, SaveAddressState>(
      'emits loading then success when add address succeeds',
      setUp: () {
        when(getAddressUseCase.addAddress(any)).thenAnswer(
          (_) async => const SuccessResponse(addresses),
        );
      },
      build: () => SaveAddressViewModel(getAddressUseCase),
      act: (viewModel) => viewModel.doEvent(AddSavedAddress(newAddress)),
      expect: () => [
        const SaveAddressState(
          addressesState: BaseState<List<AddressEntity>>(
            isLoading: true,
            errorMessage: '',
          ),
          actionError: '',
        ),
        const SaveAddressState(
          addressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            errorMessage: '',
            data: addresses,
          ),
        ),
      ],
      verify: (_) {
        final request =
            verify(getAddressUseCase.addAddress(captureAny)).captured.single
                as AddAddressRequest;
        expect(request.recipientName, 'Joudy');
        expect(request.phone, '01000000000');
        expect(request.addressLine, '12 Nile St');
        expect(request.city, 'Cairo');
        expect(request.area, 'Dokki');
        expect(request.label, 'Home');
      },
    );

    blocTest<SaveAddressViewModel, SaveAddressState>(
      'emits loading then error when add address fails',
      setUp: () {
        when(getAddressUseCase.addAddress(any)).thenAnswer(
          (_) async => ErrorResponse<List<AddressEntity>>(
            appError: BadResponseError('Add address failed'),
          ),
        );
      },
      build: () => SaveAddressViewModel(getAddressUseCase),
      act: (viewModel) => viewModel.doEvent(AddSavedAddress(newAddress)),
      expect: () => [
        const SaveAddressState(
          addressesState: BaseState<List<AddressEntity>>(
            isLoading: true,
            errorMessage: '',
          ),
          actionError: '',
        ),
        const SaveAddressState(
          addressesState: BaseState<List<AddressEntity>>(isLoading: false),
          actionError: 'Add address failed',
        ),
      ],
      verify: (_) {
        verify(getAddressUseCase.addAddress(any)).called(1);
      },
    );
  });

  group('DeleteSavedAddress', () {
    blocTest<SaveAddressViewModel, SaveAddressState>(
      'emits deleting then success without the deleted address',
      setUp: () {
        when(getAddressUseCase.deleteAddress('addr-1')).thenAnswer(
          (_) async => const SuccessResponse(true),
        );
      },
      build: () => SaveAddressViewModel(getAddressUseCase),
      seed: () => const SaveAddressState(
        addressesState: BaseState<List<AddressEntity>>(
          data: addresses,
        ),
      ),
      act: (viewModel) => viewModel.doEvent(DeleteSavedAddress('addr-1')),
      expect: () => [
        const SaveAddressState(
          addressesState: BaseState<List<AddressEntity>>(data: addresses),
          deletingId: 'addr-1',
          actionError: '',
        ),
        const SaveAddressState(
          deletingId: '',
          actionError: '',
          addressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            errorMessage: '',
            data: [],
          ),
        ),
      ],
      verify: (_) {
        verify(getAddressUseCase.deleteAddress('addr-1')).called(1);
      },
    );

    blocTest<SaveAddressViewModel, SaveAddressState>(
      'emits deleting then error when delete address fails',
      setUp: () {
        when(getAddressUseCase.deleteAddress('addr-1')).thenAnswer(
          (_) async => ErrorResponse<bool>(
            appError: BadResponseError('Delete address failed'),
          ),
        );
      },
      build: () => SaveAddressViewModel(getAddressUseCase),
      seed: () => const SaveAddressState(
        addressesState: BaseState<List<AddressEntity>>(
          data: addresses,
        ),
      ),
      act: (viewModel) => viewModel.doEvent(DeleteSavedAddress('addr-1')),
      expect: () => [
        const SaveAddressState(
          addressesState: BaseState<List<AddressEntity>>(data: addresses),
          deletingId: 'addr-1',
          actionError: '',
        ),
        const SaveAddressState(
          addressesState: BaseState<List<AddressEntity>>(data: addresses),
          deletingId: '',
          actionError: 'Delete address failed',
        ),
      ],
      verify: (_) {
        verify(getAddressUseCase.deleteAddress('addr-1')).called(1);
      },
    );
  });
}
