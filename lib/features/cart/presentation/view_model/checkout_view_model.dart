import 'dart:math';

import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/use_cases/checkout_use_cases.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckoutViewModel extends Cubit<CheckoutState> {
  CheckoutViewModel(
    this._previewCheckoutUseCase,
    this._placeOrderUseCase,
    this._processPaymentUseCase,
  ) : super(const CheckoutState());

  final PreviewCheckoutUseCase _previewCheckoutUseCase;
  final PlaceOrderUseCase _placeOrderUseCase;
  final ProcessPaymentUseCase _processPaymentUseCase;
  int _previewGeneration = 0;
  String? _previewKey;
  String? _idempotencyKey;
  bool _retryingPlaceOrder = false;

  Future<void> doEvent(CheckoutEvent event) async {
    switch (event) {
      case LoadCheckoutPreview():
        await _refreshPreview();
      case SelectCheckoutAddress():
        await _selectAddress(event.address);
      case ToggleCheckoutGift():
        _applyFormEvent(event);
        await _refreshPreview();
      case UpdateGiftRecipient():
      case SelectCheckoutPayment():
        _applyFormEvent(event);
      case SubmitPlaceOrder():
        await _placeOrder();
      case ProcessCheckoutPayment():
        await _processPayment();
      case ClearCheckoutNavigation():
        emit(state.copyWith(clearDestination: true));
    }
  }

  void _applyFormEvent(CheckoutEvent event) {
    switch (event) {
      case ToggleCheckoutGift():
        emit(state.copyWith(isGift: event.enabled));
      case UpdateGiftRecipient():
        emit(
          state.copyWith(
            recipientName: event.name ?? state.recipientName,
            recipientPhone: event.phone ?? state.recipientPhone,
          ),
        );
      case SelectCheckoutPayment():
        emit(state.copyWith(paymentMethod: event.method));
      default:
        break;
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
    final key = '${_addressId()}|${state.isGift}';
    if (state.previewState.isLoading && _previewKey == key) return;
    final generation = ++_previewGeneration;
    _previewKey = key;
    emit(
      state.copyWith(
        previewState: BaseState(isLoading: true, data: state.previewState.data),
      ),
    );
    final response = await _previewCheckoutUseCase.previewCheckout(
      addressId: _addressId(),
      gift: _gift(),
    );
    if (generation != _previewGeneration) return;
    _applyPreview(response);
  }

  void _applyPreview(BaseResponse<CartEntity> response) {
    switch (response) {
      case SuccessResponse<CartEntity>():
        emit(state.copyWith(previewState: BaseState(data: response.data)));
      case ErrorResponse<CartEntity>():
        emit(
          state.copyWith(
            previewState: BaseState(
              errorMessage: _errorMessage(response.appError),
            ),
            destination: _destinationFor(_errorCode(response.appError)),
          ),
        );
    }
  }

  Future<void> _placeOrder() async {
    if (state.submitState.isLoading) return;
    if (!state.canSubmit) {
      emit(state.copyWith(showValidation: true));
      return;
    }
    _idempotencyKey ??= _createIdempotencyKey();
    emit(
      state.copyWith(
        submitState: const BaseState(isLoading: true),
        showValidation: false,
      ),
    );
    await _applySubmit(await _submit());
  }

  Future<BaseResponse<OrderEntity>> _submit() {
    return _placeOrderUseCase.placeOrder(
      idempotencyKey: _idempotencyKey!,
      paymentMethod: CheckoutPaymentMethods.apiValue(
        state.paymentMethod,
        methods: state.paymentMethods,
      ),
      expectedTotal: state.previewState.data!.total,
      addressId: _addressId(),
      gift: _gift(),
    );
  }

  Future<void> _applySubmit(BaseResponse<OrderEntity> response) async {
    switch (response) {
      case SuccessResponse<OrderEntity>():
        _applySubmitSuccess(response.data);
      case ErrorResponse<OrderEntity>():
        await _applySubmitError(response.appError);
    }
  }

  void _applySubmitSuccess(OrderEntity order) {
    final destination = _orderDestination(order);
    _clearAttempt();
    if (destination == null) {
      emit(
        state.copyWith(
          submitState: const BaseState(errorMessage: AppString.orderFailed),
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        submitState: const BaseState(data: true),
        destination: destination,
        orderId: order.orderId,
        sessionUrl: order.sessionUrl,
        successUrl: order.successUrl,
        cancelUrl: order.cancelUrl,
      ),
    );
  }

  CheckoutDestination? _orderDestination(OrderEntity order) {
    if (order.status == 6 && order.paymentRequired == true) {
      return CheckoutDestination.payment;
    }
    if (order.status == 0 && order.paymentRequired == false) {
      return CheckoutDestination.confirmation;
    }
    return null;
  }

  Future<void> _applySubmitError(AppError error) async {
    if (_shouldRetry(error)) {
      _retryingPlaceOrder = true;
      await _applySubmit(await _submit());
      return;
    }
    _clearAttempt();
    final code = _errorCode(error);
    if (code == 'PriceChanged' && error is BadResponseError) {
      _applyPriceChanged(error);
      return;
    }
    emit(
      state.copyWith(
        submitState: BaseState(errorMessage: _errorMessage(error)),
        destination: _destinationFor(code),
      ),
    );
  }

  bool _shouldRetry(AppError error) {
    return !_retryingPlaceOrder &&
        error is BadResponseError &&
        error.code == 'DependencyUnavailable';
  }

  void _applyPriceChanged(BadResponseError error) {
    final current = state.previewState.data ?? const CartEntity.empty();
    emit(
      state.copyWith(
        previewState: BaseState(data: _summaryCart(current, error.data)),
        submitState: const BaseState(errorMessage: AppString.priceChanged),
      ),
    );
  }

  CartEntity _summaryCart(CartEntity current, Map<String, dynamic>? data) {
    final summary = data?['summary'];
    if (summary is! Map) return current;
    return current.copyWith(
      subtotal: (summary['subtotal'] as num?)?.toDouble() ?? current.subtotal,
      deliveryFee:
          (summary['deliveryFee'] as num?)?.toDouble() ?? current.deliveryFee,
      discount: (summary['discount'] as num?)?.toDouble() ?? current.discount,
      total: (summary['total'] as num?)?.toDouble() ?? current.total,
    );
  }

  String? _errorCode(AppError error) {
    return error is BadResponseError ? error.code : null;
  }

  CheckoutDestination? _destinationFor(String? code) {
    return switch (code) {
      'AddressRequired' => CheckoutDestination.addAddress,
      'CartEmpty' => CheckoutDestination.emptyCart,
      _ => null,
    };
  }

  String _errorMessage(AppError error) {
    if (error is! BadResponseError) return error.message;
    return switch (error.code) {
      'AddressNotServiceable' => AppString.deliveryUnavailable,
      'CartEmpty' => AppString.cartIsEmpty,
      'ItemsUnavailable' => _itemsUnavailableMessage(error.data),
      'PriceChanged' => AppString.priceChanged,
      _ => error.message,
    };
  }

  String _itemsUnavailableMessage(Map<String, dynamic>? data) {
    final items = data?['items'];
    if (items is! List || items.isEmpty) return AppString.itemsUnavailable;
    final lines = items
        .map(_itemUnavailableLine)
        .where((line) => line.isNotEmpty);
    if (lines.isEmpty) return AppString.itemsUnavailable;
    return lines.join('\n');
  }

  String _itemUnavailableLine(dynamic item) {
    if (item is! Map) return item?.toString() ?? '';
    final name = item['name'] ?? item['productName'] ?? item['productId'];
    final reason = item['reason'] ?? item['message'];
    if (name != null && reason != null) return '$name: $reason';
    final requested = item['requestedQuantity'];
    final available = item['availableQuantity'];
    if (name != null && requested != null && available != null) {
      return '$name: $requested requested, $available available';
    }
    if (name != null && available != null) {
      return '$name: $available available';
    }
    return (name ?? reason)?.toString() ?? '';
  }

  String? _addressId() {
    if (state.isGift) return null;
    final address = state.selectedAddress;
    if (address == null || address.isDefault) return null;
    final id = address.id;
    if (id == null || id.isEmpty) return null;
    return id;
  }

  CheckoutGiftEntity? _gift() {
    if (!state.isGift) return null;
    final address = state.selectedAddress;
    if (address == null) return null;
    return CheckoutGiftEntity(
      recipientName: state.recipientName,
      phone: state.recipientPhone,
      addressLine: address.address ?? '',
      city: address.city ?? '',
      area: address.area ?? '',
      lat: address.latitude,
      lng: address.longitude,
    );
  }

  void _clearAttempt() {
    _idempotencyKey = null;
    _retryingPlaceOrder = false;
  }

  String _createIdempotencyKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  Future<void> _processPayment() async {
    if (state.paymentState.isLoading) return;
    emit(state.copyWith(paymentState: const BaseState(isLoading: true)));
    final response = await _processPaymentUseCase.processPayment();
    switch (response) {
      case SuccessResponse<bool>():
        emit(
          state.copyWith(
            paymentState: const BaseState(data: true),
            destination: CheckoutDestination.confirmation,
          ),
        );
      case ErrorResponse<bool>():
        emit(
          state.copyWith(
            paymentState: BaseState(errorMessage: response.errorMessage),
          ),
        );
    }
  }
}
