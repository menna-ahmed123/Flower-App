import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/utils/commerce_widgets/default_address_view_model/default_address_event.dart';
import 'package:flower_app/core/utils/commerce_widgets/default_address_view_model/default_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/delete_address_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class DefaultAddressViewModel extends Cubit<DefaultAddressState> {
  DefaultAddressViewModel(this.getAddressUseCase, this.deleteAddressUseCase)
    : super(const DefaultAddressState());
  final GetAddressesUseCase getAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;

  void doEvent(DefaultAddressEvent event) {
    switch (event) {
      case LoadSavedAddresses():
        _loadAddresses();
        break;
     case DeleteSavedAddress():
      if (state.deletingId.isNotEmpty) {
        return;
      }

      _deleteAddress(event.id);
      break;
    }
  }

  Future<void> _loadAddresses() async {
    emit(
      state.copyWith(
        defaultAddressesState: state.defaultAddressesState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await getAddressUseCase.getAddresses();
    switch (response) {
      case SuccessResponse<List<AddressEntity>>():
        emit(
          state.copyWith(
            defaultAddressesState: state.defaultAddressesState.copyWith(
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
            defaultAddressesState: state.defaultAddressesState.copyWith(
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

    final response = await deleteAddressUseCase.deleteAddress(id);

    switch (response) {
      case SuccessResponse<bool>():
        final updated = [...?state.defaultAddressesState.data]
          ..removeWhere((address) => address.id == id);

        emit(
          state.copyWith(
            deletingId: '',
            actionError: '',
            defaultAddressesState: state.defaultAddressesState.copyWith(
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
