import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/utils/commerce_widgets/default_address_view_model/default_address_event.dart';
import 'package:flower_app/core/utils/commerce_widgets/default_address_view_model/default_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
@Singleton()
class DefaultAddressViewModel extends Cubit<DefaultAddressState> {
  DefaultAddressViewModel(this.getAddressUseCase)
    : super(const DefaultAddressState());
  final GetAddressUseCase getAddressUseCase;
  void doEvent(DefaultAddressEvent event) {
    switch (event) {
      case LoadSavedAddresses():
        _loadAddresses();
        break;
        }}
  Future<void> _loadAddresses() async {
    emit(
      state.copyWith(
        addressesState: state.addressesState.copyWith(
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

}
