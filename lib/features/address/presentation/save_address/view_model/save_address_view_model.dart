import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/add_address_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/update_address_use_case.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_event.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveAddressViewModel extends Cubit<SaveAddressState> {
  SaveAddressViewModel(
    this.addAddressUseCase,
    this.updateAddressUseCase,
  ) : super(const SaveAddressState());

  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;

  void doEvent(SaveAddressEvent event) {
    switch (event) {
      case AddAddress():
        _addAddress(event.address);
        break;

      case EditAddress():
        _updateAddress(event.address);
        break;
    }
  }

  Future<void> _addAddress(AddressEntity address) async {
    emit(
      state.copyWith(
        isSaved: false,
        saveAddressState: state.saveAddressState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await addAddressUseCase.addAddress(
      _toRequest(address),
    );

    switch (response) {
      case SuccessResponse<AddressEntity>(:final data):

        emit(
          state.copyWith(
            isSaved: true,
            saveAddressState: state.saveAddressState.copyWith(
              isLoading: false,
              errorMessage: '',
              data: data,
            ),
          ),
        );

        break;

      case ErrorResponse<AddressEntity>(:final errorMessage):
        emit(
          state.copyWith(
            isSaved: false,
            saveAddressState: state.saveAddressState.copyWith(
              isLoading: false,
              errorMessage: errorMessage,
            ),
          ),
        );

        break;
    }
  }

  Future<void> _updateAddress(AddressEntity address) async {
    final id = address.id;

    if (id == null || id.isEmpty) return;

    emit(
      state.copyWith(
        isSaved: false,
        saveAddressState: state.saveAddressState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await updateAddressUseCase.updateAddress(
      id,
      _toRequest(address),
    );

    switch (response) {
      case SuccessResponse<List<AddressEntity>>():

        emit(
          state.copyWith(
            isSaved: true,
            saveAddressState: state.saveAddressState.copyWith(
              isLoading: false,
              errorMessage: '',
            ),
          ),
        );

        break;

      case ErrorResponse<List<AddressEntity>>( :final errorMessage):
        emit(
          state.copyWith(
            isSaved: false,
            saveAddressState: state.saveAddressState.copyWith(
              isLoading: false,
              errorMessage: errorMessage,
            ),
          ),
        );

        break;
    }
  }

  AddAddressRequest _toRequest(AddressEntity address) {
    return AddAddressRequest(
      recipientName: address.recipientName ?? '',
      phone: address.phoneNumber ?? '',
      addressLine: address.address ?? '',
      city: address.city ?? '',
      area: address.area ?? '',
      label: address.label ?? 'Home',
    );
  }
}