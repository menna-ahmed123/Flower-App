
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'payment_event.dart';
import 'payment_state.dart';

@injectable
class PaymentViewModel extends Cubit<PaymentState> {
  PaymentViewModel()
      : super(const PaymentState());


  void doEvent(PaymentEvent event) {
    switch (event) {
      case StartPayment():
        _startPayment(event);
        break;

      case PaymentSuccess():
        _paymentSuccess();
        break;

      case PaymentCancelled():
        _paymentCancelled();
        break;

      case PaymentFailed():
        _paymentFailed();
        break;

      case ResetPayment():
        _resetPayment();
        break;
    }
  }

  Future<void> _startPayment(StartPayment event) async {
    if (state.paymentState.isLoading) return;

    if (event.sessionUrl.trim().isEmpty) {
      emit(
        state.copyWith(
          paymentState: state.paymentState.copyWith(
            isLoading: false,
            errorMessage: 'Payment session is unavailable',
          ),
          errorMessage: 'Payment session is unavailable',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        paymentState: state.paymentState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
        sessionUrl: event.sessionUrl,
        successUrl: event.successUrl,
        cancelUrl: event.cancelUrl,
        clearError: true,
      ),
    );

    if (isClosed) return;

    emit(
      state.copyWith(
        paymentState: state.paymentState.copyWith(
          isLoading: false,
          errorMessage: '',
        ),
      ),
    );
  }

  void _paymentSuccess() {
    emit(
      state.copyWith(
        paymentState: state.paymentState.copyWith(
          isLoading: false,
          errorMessage: '',
        ),
        clearError: true,
      ),
    );
  }

  void _paymentCancelled() {
    emit(
      state.copyWith(
        paymentState: state.paymentState.copyWith(
          isLoading: false,
          errorMessage: '',
        ),
        clearError: true,
      ),
    );
  }

  void _paymentFailed() {
    emit(
      state.copyWith(
        paymentState: state.paymentState.copyWith(
          isLoading: false,
          errorMessage: 'Payment failed',
        ),
        errorMessage: 'Payment failed',
      ),
    );
  }

  void _resetPayment() {
    emit(const PaymentState());
  }
}
