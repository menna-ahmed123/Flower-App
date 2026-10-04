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

const _paymentCurrency = 'egp';

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
  int _detailsGeneration = 0;
  int _estimateGeneration = 0;
  bool _detailsInFlight = false;
  String? _cartId;
  String? _idempotencyKey;
  double? _orderTotal;
  bool _retryingPlaceOrder = false;

  Future<void> doEvent(CheckoutEvent event) async {
    switch (event) {
      case LoadCheckoutPreview():
        await _loadDetails();
      case SelectCheckoutAddress():
        await _selectAddress(event.address);
      case ToggleCheckoutGift():
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

  Future<void> _loadDetails() async {
    final generation = ++_detailsGeneration;
    _detailsInFlight = true;
    _emitPreviewLoading();
    final cart = await _loadedCart(generation);
    if (cart == null) {
      _finishDetails(generation);
      return;
    }
    await _fetchDetails(generation, cart.id);
    _finishDetails(generation);
    if (generation != _detailsGeneration || _addressId() == null) return;
    await _estimate();
  }

  void _finishDetails(int generation) {
    if (generation != _detailsGeneration) return;
    _detailsInFlight = false;
  }

  Future<CartEntity?> _loadedCart(int generation) async {
    final response = await _previewCheckoutUseCase.getCart();
    if (generation != _detailsGeneration) return null;
    if (response is ErrorResponse<CartEntity>) {
      _applyDetails(response);
      return null;
    }
    final cart = (response as SuccessResponse<CartEntity>).data;
    if (!_cartIsEmpty(cart)) return cart;
    _emitEmptyCart();
    return null;
  }

  Future<void> _fetchDetails(int generation, String cartId) async {
    _cartId = cartId;
    final response = await _previewCheckoutUseCase.checkoutDetails(
      cartId: cartId,
    );
    if (generation != _detailsGeneration) return;
    _applyDetails(response);
  }

  bool _cartIsEmpty(CartEntity cart) {
    return cart.items.isEmpty && cart.itemCount == 0;
  }

  void _applyDetails(BaseResponse<CartEntity> response) {
    switch (response) {
      case SuccessResponse<CartEntity>():
        _emitLoaded(response.data);
      case ErrorResponse<CartEntity>():
        _emitPreviewError(response.appError);
    }
  }

  void _emitLoaded(CartEntity cart) {
    emit(
      state.copyWith(
        previewState: BaseState(
          data: cart,
          errorMessage: cart.isServiceable ? '' : AppString.deliveryUnavailable,
        ),
      ),
    );
  }

  void _emitPreviewError(AppError error) {
    emit(
      state.copyWith(
        previewState: BaseState(errorMessage: _errorMessage(error)),
        destination: _destinationFor(_errorCode(error)),
      ),
    );
  }

  void _emitEmptyCart() {
    emit(
      state.copyWith(
        previewState: const BaseState(errorMessage: AppString.cartIsEmpty),
        destination: CheckoutDestination.emptyCart,
      ),
    );
  }

  Future<void> _selectAddress(AddressEntity address) async {
    if (_sameLoadedAddress(address)) return;
    emit(state.copyWith(selectedAddress: address));
    if (_detailsInFlight) return;
    await _estimate();
  }

  bool _sameLoadedAddress(AddressEntity address) {
    return state.selectedAddress?.id == address.id &&
        state.previewState.data != null &&
        !state.previewState.isLoading;
  }

  Future<void> _estimate() async {
    final addressId = _addressId();
    final cartId = await _ensureCartId();
    if (addressId == null || cartId == null) return;
    final generation = ++_estimateGeneration;
    _emitPreviewLoading();
    final response = await _previewCheckoutUseCase.estimateDelivery(
      addressId: addressId,
      cartId: cartId,
    );
    if (generation != _estimateGeneration) return;
    _applyEstimate(response);
  }

  Future<String?> _ensureCartId() async {
    final existing = _cartId;
    if (existing != null && existing.isNotEmpty) return existing;
    final response = await _previewCheckoutUseCase.getCart();
    if (response is! SuccessResponse<CartEntity> || response.data.id.isEmpty) {
      return null;
    }
    _cartId = response.data.id;
    return _cartId;
  }

  void _applyEstimate(BaseResponse<DeliveryEstimateEntity> response) {
    switch (response) {
      case SuccessResponse<DeliveryEstimateEntity>():
        _emitLoaded(_mergeEstimate(state.previewState.data, response.data));
      case ErrorResponse<DeliveryEstimateEntity>():
        _emitEstimateError(response.appError);
    }
  }

  void _emitEstimateError(AppError error) {
    final code = _errorCode(error);
    final current = state.previewState.data;
    emit(
      state.copyWith(
        previewState: BaseState(
          data: code == 'AddressNotServiceable' && current != null
              ? current.copyWith(isServiceable: false)
              : current,
          errorMessage: _errorMessage(error),
        ),
      ),
    );
  }

  CartEntity _mergeEstimate(
    CartEntity? current,
    DeliveryEstimateEntity estimate,
  ) {
    final base = current ?? const CartEntity.empty();
    if (!estimate.hasData) return base;
    final subtotal = estimate.subtotal ?? base.subtotal;
    final deliveryFee = estimate.deliveryFee ?? base.deliveryFee;
    final hasPrice =
        estimate.subtotal != null ||
        estimate.deliveryFee != null ||
        estimate.total != null;
    final total = estimate.total ??
        (hasPrice ? subtotal + deliveryFee - base.discount : base.total);
    return base.copyWith(
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      isServiceable: estimate.isServiceable,
      estimatedDeliveryAt: estimate.estimatedDeliveryAt,
      updateEstimatedDeliveryAt: estimate.includesDeliveryAt,
    );
  }

  Future<void> _placeOrder() async {
    if (state.submitState.isLoading) return;
    final method = _selectedPayment();
    if (!state.canSubmit || method == null || _addressId() == null) {
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
    await _applySubmit(await _submit(method));
  }

  Future<BaseResponse<OrderEntity>> _submit(PaymentMethodEntity method) {
    return _placeOrderUseCase.placeOrder(
      idempotencyKey: _idempotencyKey!,
      cartId: _cartId ?? state.previewState.data?.id ?? '',
      addressId: _addressId()!,
      isGift: state.isGift,
      recipientName: state.isGift ? state.recipientName : null,
      recipientPhone: state.isGift ? state.recipientPhone : null,
      paymentMethod: method.apiMethod,
      paymentGateway: method.gateway,
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
    _orderTotal = order.total;
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
        sessionUrl: order.sessionUrl.isEmpty ? null : order.sessionUrl,
        stripeSessionId: order.stripeSessionId.isEmpty
            ? null
            : order.stripeSessionId,
      ),
    );
  }

  CheckoutDestination? _orderDestination(OrderEntity order) {
    if (order.orderId.isEmpty) return null;
    if (_isCard(_selectedPayment())) return CheckoutDestination.payment;
    if (order.status == 'PLACED') return CheckoutDestination.confirmation;
    return null;
  }

  bool _isCard(PaymentMethodEntity? method) {
    return method?.apiMethod.toUpperCase() == 'CARD';
  }

  PaymentMethodEntity? _selectedPayment() {
    for (final method in state.paymentMethods) {
      if (method.name == state.paymentMethod) return method;
    }
    return null;
  }

  Future<void> _applySubmitError(AppError error) async {
    if (_shouldRetry(error)) {
      _retryingPlaceOrder = true;
      final method = _selectedPayment();
      if (method != null) await _applySubmit(await _submit(method));
      return;
    }
    _clearAttempt();
    if (_errorCode(error) == 'PriceChanged' && error is BadResponseError) {
      _applyPriceChanged(error);
      return;
    }
    emit(
      state.copyWith(
        submitState: BaseState(errorMessage: _errorMessage(error)),
        destination: _destinationFor(_errorCode(error)),
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
    if (error is! BadResponseError) return null;
    return switch (error.code) {
      'Cart.Empty' => 'CartEmpty',
      'Order.NotServiceable' => 'AddressNotServiceable',
      _ => error.code,
    };
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
    return switch (_errorCode(error)) {
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
    return _quantityLine(name, item);
  }

  String _quantityLine(Object? name, Map<dynamic, dynamic> item) {
    final requested = item['requestedQuantity'];
    final available = item['availableQuantity'];
    if (name != null && requested != null && available != null) {
      return '$name: $requested requested, $available available';
    }
    if (name != null && available != null) return '$name: $available available';
    return (name ?? item['reason'])?.toString() ?? '';
  }

  String? _addressId() {
    final id = state.selectedAddress?.id;
    if (id == null || id.isEmpty) return null;
    return id;
  }

  void _emitPreviewLoading() {
    emit(
      state.copyWith(
        previewState: BaseState(isLoading: true, data: state.previewState.data),
      ),
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
    final hex = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0'));
    final value = hex.join();
    return '${value.substring(0, 8)}-${value.substring(8, 12)}-'
        '${value.substring(12, 16)}-${value.substring(16, 20)}-'
        '${value.substring(20)}';
  }

  Future<void> _processPayment() async {
    if (state.paymentState.isLoading) return;
    if ((state.sessionUrl ?? '').isNotEmpty) {
      emit(state.copyWith(paymentState: const BaseState(data: true)));
      return;
    }
    final orderId = state.orderId ?? '';
    if (orderId.isEmpty) {
      _emitPaymentError(AppString.paymentFailed);
      return;
    }
    emit(state.copyWith(paymentState: const BaseState(isLoading: true)));
    final response = await _processPaymentUseCase.createPaymentCheckout(
      orderId: orderId,
      amountTotal: _paymentAmount(),
      currency: _paymentCurrency,
    );
    _applyPayment(response);
  }

  double _paymentAmount() {
    final ordered = _orderTotal ?? 0;
    if (ordered > 0) return ordered;
    return state.previewState.data?.total ?? 0;
  }

  void _applyPayment(BaseResponse<PaymentCheckoutEntity> response) {
    switch (response) {
      case SuccessResponse<PaymentCheckoutEntity>():
        _emitPaymentSession(response.data);
      case ErrorResponse<PaymentCheckoutEntity>():
        _emitPaymentError(
          response.errorMessage.isEmpty
              ? AppString.paymentFailed
              : response.errorMessage,
        );
    }
  }

  void _emitPaymentSession(PaymentCheckoutEntity session) {
    if (session.checkoutUrl.isEmpty) {
      _emitPaymentError(AppString.paymentFailed);
      return;
    }
    emit(
      state.copyWith(
        paymentState: const BaseState(data: true),
        sessionUrl: session.checkoutUrl,
        stripeSessionId: session.stripeSessionId,
        paymentAttemptId: session.paymentAttemptId,
      ),
    );
  }

  void _emitPaymentError(String message) {
    emit(state.copyWith(paymentState: BaseState(errorMessage: message)));
  }
}
