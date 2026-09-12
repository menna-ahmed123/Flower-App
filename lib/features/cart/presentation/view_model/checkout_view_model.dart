import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/use_cases/cart_use_case.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckoutViewModel extends Cubit<CheckoutState> {
  CheckoutViewModel(this._cartUseCase) : super(const CheckoutState());

  final CartUseCase _cartUseCase;
  int _previewGeneration = 0;
  String? _previewAddressId;

  Future<void> doEvent(CheckoutEvent event) async {
    switch (event) {
      case LoadCheckoutPreview():
        await _refreshPreview();
      case SelectCheckoutAddress():
        await _selectAddress(event.address);
      case ToggleCheckoutGift():
        emit(state.copyWith(isGift: event.enabled));
      case UpdateGiftRecipient():
        emit(state.copyWith(
          recipientName: event.name ?? state.recipientName,
          recipientPhone: event.phone ?? state.recipientPhone,
        ));
      case SelectCheckoutPayment():
        emit(state.copyWith(paymentMethod: event.method));
      case SubmitPlaceOrder():
        await _placeOrder();
      case ProcessCheckoutPayment():
        await _processPayment();
      case ClearCheckoutNavigation():
        emit(state.copyWith(clearDestination: true));
    }
  }

  Future<void> _selectAddress(AddressEntity address) async {
    if (state.selectedAddress?.id == address.id &&
        state.previewState.data != null &&
        !state.previewState.isLoading) {
      return;
    }
    emit(state.copyWith(selectedAddress: address));
    await _refreshPreview();
  }

  Future<void> _refreshPreview() async {
    final addressId = state.selectedAddress?.id;
    if (state.previewState.isLoading && _previewAddressId == addressId) {
      return;
    }
    final generation = ++_previewGeneration;
    _previewAddressId = addressId;
    emit(state.copyWith(previewState: const BaseState(isLoading: true)));
    final response = await _cartUseCase.getCart();
    if (generation != _previewGeneration) return;
    _applyPreview(response);
  }

  void _applyPreview(BaseResponse<CartEntity> response) {
    switch (response) {
      case SuccessResponse<CartEntity>():
        emit(state.copyWith(previewState: BaseState(data: response.data)));
      case ErrorResponse<CartEntity>():
        emit(state.copyWith(
          previewState: BaseState(errorMessage: response.errorMessage),
        ));
    }
  }

  Future<void> _placeOrder() async {
    if (state.submitState.isLoading) return;
    if (!state.canSubmit) {
      emit(state.copyWith(showValidation: true));
      return;
    }
    emit(state.copyWith(
      submitState: const BaseState(isLoading: true),
      showValidation: false,
    ));
    _applySubmit(await _cartUseCase.placeOrder());
  }

  void _applySubmit(BaseResponse<bool> response) {
    switch (response) {
      case SuccessResponse<bool>():
        emit(state.copyWith(
          submitState: const BaseState(data: true),
          destination: CheckoutPaymentMethods.requiresCharge(state.paymentMethod)
              ? CheckoutDestination.payment
              : CheckoutDestination.confirmation,
        ));
      case ErrorResponse<bool>():
        emit(state.copyWith(
          submitState: BaseState(errorMessage: response.errorMessage),
        ));
    }
  }

  Future<void> _processPayment() async {
    if (state.paymentState.isLoading) return;
    emit(state.copyWith(paymentState: const BaseState(isLoading: true)));
    final response = await _cartUseCase.processPayment();
    switch (response) {
      case SuccessResponse<bool>():
        emit(state.copyWith(
          paymentState: const BaseState(data: true),
          destination: CheckoutDestination.confirmation,
        ));
      case ErrorResponse<bool>():
        emit(state.copyWith(
          paymentState: BaseState(errorMessage: response.errorMessage),
        ));
    }
  }
}
