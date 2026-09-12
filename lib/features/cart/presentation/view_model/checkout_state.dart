import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';

abstract final class CheckoutPaymentMethods {
  static const String cashOnDelivery = AppString.cashOnDelivery;
  static const String creditCard = AppString.creditCard;

  static const List<String> all = [cashOnDelivery, creditCard];

  static bool requiresCharge(String? method) => method == creditCard;
}

enum CheckoutDestination { payment, confirmation }

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
        !submitState.isLoading;
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
      ];
}
