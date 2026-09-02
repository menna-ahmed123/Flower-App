import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_delete_address_use_case.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_event.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveAddressViewModel extends Cubit<SaveAddressState> {
  SaveAddressViewModel(this.getDeleteAddressUseCase, this.getAddressUseCase)
    : super(const SaveAddressState());

  final GetDeleteAddressUseCase getDeleteAddressUseCase;
  final GetAddressUseCase getAddressUseCase;

  void doEvent(SaveAddressEvent event) {
    switch (event) {
      case DeleteSavedAddress():
        _deleteAddress(event.id);
        break;
    }
  }

  Future<void> _deleteAddress(String id) async {
    emit(state.copyWith(deletingId: id, actionError: ''));

    final response = await getDeleteAddressUseCase.deleteAddress(id);

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
