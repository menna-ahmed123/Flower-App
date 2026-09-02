import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/address_use_case.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_event.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveAddressViewModel extends Cubit<SaveAddressState> {
  SaveAddressViewModel(this._getAddressUseCase)
    : super(const SaveAddressState());

  final GetAddressUseCase _getAddressUseCase;

  void doEvent(SaveAddressEvent event) {
    switch (event) {
      case LoadSavedAddresses():
        _loadAddresses();
        break;
      case DeleteSavedAddress():
        _deleteAddress(event.id);
        break;
    }
  }

  Future<void> _loadAddresses() async {
    emit(
      state.copyWith(
        addressesState: state.addressesState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await _getAddressUseCase.getAddresses();
    switch (response) {
      case SuccessResponse<List<AddressEntity>>():
        emit(
          state.copyWith(
            addressesState: state.addressesState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );
        break;
      case ErrorResponse<List<AddressEntity>>():
        emit(
          state.copyWith(
            addressesState: state.addressesState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }


  Future<void> _deleteAddress(String id) async {
    emit(state.copyWith(deletingId: id, actionError: ''));

    final response = await _getAddressUseCase.deleteAddress(id);

    switch (response) {
      case SuccessResponse<bool>():
        final updated = [...?state.addressesState.data]
          ..removeWhere((address) => address.id == id);

        emit(
          state.copyWith(
            deletingId: '',
            actionError: '',
            addressesState: state.addressesState.copyWith(
              isLoading: false,
              data: updated,
              errorMessage: '',
            ),
          ),
        );
        break;
      case ErrorResponse<bool>():
        emit(
          state.copyWith(deletingId: '', actionError: response.errorMessage),
        );
        break;
    }
  }
}
