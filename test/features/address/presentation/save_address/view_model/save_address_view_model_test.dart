import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/add_address_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/update_address_use_case.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_event.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_state.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_address_view_model_test.mocks.dart';

@GenerateMocks([AddAddressUseCase, UpdateAddressUseCase])
void main() {
  provideDummy<BaseResponse<AddressEntity>>(
    const SuccessResponse<AddressEntity>(
      AddressEntity(
        id: '1',
        recipientName: 'Menna',
        phoneNumber: '01012345678',
        address: 'Street 10',
        city: 'Cairo',
        area: 'Nasr City',
        label: 'Home',
      ),
    ),
  );

  provideDummy<BaseResponse<List<AddressEntity>>>(
    const SuccessResponse<List<AddressEntity>>([]),
  );

  provideDummy<AddAddressRequest>(
    AddAddressRequest(
      recipientName: 'Menna',
      recipientPhone: '01012345678',
      addressLine: 'Street 10',
      governorateId: 1,
      cityId: 1,
      area: 'Nasr City',
      label: 'Home',
    ),
  );

  late MockAddAddressUseCase addAddressUseCase;
  late MockUpdateAddressUseCase updateAddressUseCase;
  late SaveAddressViewModel viewModel;

  setUp(() {
    addAddressUseCase = MockAddAddressUseCase();
    updateAddressUseCase = MockUpdateAddressUseCase();

    viewModel = SaveAddressViewModel(
      addAddressUseCase,
      updateAddressUseCase,
    );
  });

  const address = AddressEntity(
    id: '1',
    recipientName: 'Menna',
    phoneNumber: '01012345678',
    address: 'Street 10',
    city: 'Cairo',
    area: 'Nasr City',
    label: 'Home',
  );

  const addressWithoutId = AddressEntity(
    recipientName: 'Menna',
    phoneNumber: '01012345678',
    address: 'Street 10',
    city: 'Cairo',
    area: 'Nasr City',
    label: 'Home',
  );

  const dummyErrorMessage = 'Dummy Message';

  // ============================================================
  // AddAddress
  // ============================================================

  group('AddAddress', () {
    test('emits loading then saved state on success', () async {
      when(
        addAddressUseCase.addAddress(any),
      ).thenAnswer(
        (_) async => const SuccessResponse<AddressEntity>(address),
      );

      final future = expectLater(
        viewModel.stream,
        emitsInOrder([
          isA<SaveAddressState>()
              .having((s) => s.saveAddressState.isLoading, 'isLoading', true),
          isA<SaveAddressState>()
              .having((s) => s.saveAddressState.isLoading, 'isLoading', false)
              .having((s) => s.saveAddressState.data, 'data', address)
              .having((s) => s.isSaved, 'isSaved', true),
        ]),
      );

      viewModel.doEvent(AddAddress(address));

      await future;

      verify(addAddressUseCase.addAddress(any)).called(1);
      verifyNoMoreInteractions(updateAddressUseCase);
    });

    test('emits error message on failure', () async {
      final error = BadResponseError(dummyErrorMessage);

      when(
        addAddressUseCase.addAddress(any),
      ).thenAnswer(
        (_) async => ErrorResponse<AddressEntity>(appError: error),
      );

      final future = expectLater(
        viewModel.stream,
        emitsInOrder([
          isA<SaveAddressState>()
              .having((s) => s.saveAddressState.isLoading, 'isLoading', true),
          isA<SaveAddressState>()
              .having(
                (s) => s.saveAddressState.errorMessage,
                'errorMessage',
                dummyErrorMessage,
              )
              .having((s) => s.isSaved, 'isSaved', false),
        ]),
      );

      viewModel.doEvent(AddAddress(address));

      await future;

      verify(addAddressUseCase.addAddress(any)).called(1);
    });

    test('builds request from address fields', () async {
      when(
        addAddressUseCase.addAddress(any),
      ).thenAnswer(
        (_) async => const SuccessResponse<AddressEntity>(address),
      );

      final future = expectLater(
        viewModel.stream,
        emitsInOrder([
          isA<SaveAddressState>()
              .having((s) => s.saveAddressState.isLoading, 'isLoading', true),
          isA<SaveAddressState>()
              .having((s) => s.saveAddressState.isLoading, 'isLoading', false),
        ]),
      );

      viewModel.doEvent(AddAddress(address));

      await future;

      final captured =
          verify(addAddressUseCase.addAddress(captureAny)).captured;
      final request = captured.single as AddAddressRequest;

      expect(request.recipientName, 'Menna');
      expect(request.recipientPhone, '01012345678');
      expect(request.addressLine, 'Street 10');
      expect(request.area, 'Nasr City');
      expect(request.label, 'Home');
    });
  });

  // ============================================================
  // EditAddress
  // ============================================================

  group('EditAddress', () {
    test('emits saved state on success', () async {
      when(
        updateAddressUseCase.updateAddress(any, any),
      ).thenAnswer(
        (_) async => const SuccessResponse<List<AddressEntity>>([]),
      );

      final future = expectLater(
        viewModel.stream,
        emitsInOrder([
          isA<SaveAddressState>()
              .having((s) => s.saveAddressState.isLoading, 'isLoading', true),
          isA<SaveAddressState>()
              .having((s) => s.saveAddressState.isLoading, 'isLoading', false)
              .having((s) => s.isSaved, 'isSaved', true),
        ]),
      );

      viewModel.doEvent(EditAddress(address));

      await future;

      verify(updateAddressUseCase.updateAddress('1', any)).called(1);
      verifyNoMoreInteractions(addAddressUseCase);
    });

    test('emits error message on failure', () async {
      final error = BadResponseError(dummyErrorMessage);

      when(
        updateAddressUseCase.updateAddress(any, any),
      ).thenAnswer(
        (_) async => ErrorResponse<List<AddressEntity>>(appError: error),
      );

      final future = expectLater(
        viewModel.stream,
        emitsInOrder([
          isA<SaveAddressState>()
              .having((s) => s.saveAddressState.isLoading, 'isLoading', true),
          isA<SaveAddressState>()
              .having(
                (s) => s.saveAddressState.errorMessage,
                'errorMessage',
                dummyErrorMessage,
              )
              .having((s) => s.isSaved, 'isSaved', false),
        ]),
      );

      viewModel.doEvent(EditAddress(address));

      await future;
    });

    test('ignores addresses without an id', () async {
      viewModel.doEvent(EditAddress(addressWithoutId));

      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state, const SaveAddressState());
      verifyNever(updateAddressUseCase.updateAddress(any, any));
    });
  });
}
