
import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';

class PaymentState extends Equatable {
  final BaseState<OrderEntity> paymentState;
  final String? sessionUrl;
  final String? successUrl;
  final String? cancelUrl;
  final String? errorMessage;

  const PaymentState({
    this.paymentState = const BaseState<OrderEntity>(),
    this.sessionUrl,
    this.successUrl,
    this.cancelUrl,
    this.errorMessage,
  });

  PaymentState copyWith({
    BaseState<OrderEntity>? paymentState,
    String? sessionUrl,
    String? successUrl,
    String? cancelUrl,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PaymentState(
      paymentState: paymentState ?? this.paymentState,
      sessionUrl: sessionUrl ?? this.sessionUrl,
      successUrl: successUrl ?? this.successUrl,
      cancelUrl: cancelUrl ?? this.cancelUrl,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        paymentState,
        sessionUrl,
        successUrl,
        cancelUrl,
        errorMessage,
      ];
}
