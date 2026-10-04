import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';

abstract final class CheckoutPaymentMethods {
  static const String cashOnDelivery = AppString.cashOnDelivery;
  static const String creditCard = AppString.creditCard;
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
    this.stripeSessionId,
    this.paymentAttemptId,
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
  final String? stripeSessionId;
  final String? paymentAttemptId;

  List<PaymentMethodEntity> get paymentMethods {
    return previewState.data?.paymentMethods ?? const [];
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
        previewState.data != null &&
        previewState.data!.isServiceable;
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
    String? stripeSessionId,
    String? paymentAttemptId,
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
      stripeSessionId: stripeSessionId ?? this.stripeSessionId,
      paymentAttemptId: paymentAttemptId ?? this.paymentAttemptId,
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
    stripeSessionId,
    paymentAttemptId,
  ];
}
