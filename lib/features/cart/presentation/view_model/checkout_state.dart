import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';

abstract final class CheckoutPaymentMethods {
  static const String cashOnDelivery = AppString.cashOnDelivery;
  static const String creditCard = AppString.creditCard;

  static bool requiresCharge(String? method) => method == creditCard;

  static int apiValue(
    String? method, {
    List<PaymentMethodEntity> methods = const [],
  }) {
    for (final item in methods) {
      if (item.name == method) return item.value;
    }
    return method == creditCard ? 2 : 1;
  }
}

enum CheckoutDestination { payment, confirmation, addAddress, emptyCart }

class CheckoutState extends Equatable {
  const CheckoutState({
    this.selectedAddress,
    this.isGift = false,
    this.recipientName = '',
    this.recipientPhone = '',
    this.paymentMethod,
    this.showValidation = false,
    this.previewState = const BaseState(),
    this.submitState = const BaseState(),
    this.paymentState = const BaseState(),
    this.destination,
    this.orderId,
    this.sessionUrl,
    this.successUrl,
    this.cancelUrl,
  });

  final AddressEntity? selectedAddress;
  final bool isGift;
  final String recipientName;
  final String recipientPhone;
  final String? paymentMethod;
  final bool showValidation;
  final BaseState<CartEntity> previewState;
  final BaseState<bool> submitState;
  final BaseState<bool> paymentState;
  final CheckoutDestination? destination;
  final String? orderId;
  final String? sessionUrl;
  final String? successUrl;
  final String? cancelUrl;

  List<PaymentMethodEntity> get paymentMethods {
    final methods = previewState.data?.paymentMethods ?? const [];
    if (methods.isNotEmpty) return methods;
    return const [
      PaymentMethodEntity(
        name: CheckoutPaymentMethods.cashOnDelivery,
        value: 1,
      ),
      PaymentMethodEntity(name: CheckoutPaymentMethods.creditCard, value: 2),
    ];
  }

  bool get hasAddress => (selectedAddress?.id ?? '').isNotEmpty;

  bool get hasPaymentMethod => (paymentMethod ?? '').isNotEmpty;

  bool get isGiftRecipientValid {
    if (!isGift) return true;
    return AppValidators.validateRecipientName(recipientName) == null &&
        AppValidators.phoneValidator(recipientPhone) == null;
  }

  bool get canSubmit {
    return hasAddress &&
        hasPaymentMethod &&
        isGiftRecipientValid &&
        !submitState.isLoading &&
        !previewState.isLoading &&
        previewState.data != null;
  }

  CheckoutState copyWith({
    AddressEntity? selectedAddress,
    bool? isGift,
    String? recipientName,
    String? recipientPhone,
    String? paymentMethod,
    bool? showValidation,
    BaseState<CartEntity>? previewState,
    BaseState<bool>? submitState,
    BaseState<bool>? paymentState,
    CheckoutDestination? destination,
    bool clearDestination = false,
    String? orderId,
    String? sessionUrl,
    String? successUrl,
    String? cancelUrl,
  }) {
    return CheckoutState(
      selectedAddress: selectedAddress ?? this.selectedAddress,
      isGift: isGift ?? this.isGift,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      showValidation: showValidation ?? this.showValidation,
      previewState: previewState ?? this.previewState,
      submitState: submitState ?? this.submitState,
      paymentState: paymentState ?? this.paymentState,
      destination: clearDestination ? null : (destination ?? this.destination),
      orderId: orderId ?? this.orderId,
      sessionUrl: sessionUrl ?? this.sessionUrl,
      successUrl: successUrl ?? this.successUrl,
      cancelUrl: cancelUrl ?? this.cancelUrl,
    );
  }

  @override
  List<Object?> get props => [
    selectedAddress,
    isGift,
    recipientName,
    recipientPhone,
    paymentMethod,
    showValidation,
    previewState,
    submitState,
    paymentState,
    destination,
    orderId,
    sessionUrl,
    successUrl,
    cancelUrl,
  ];
}
