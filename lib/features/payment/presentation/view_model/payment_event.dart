sealed class PaymentEvent {
  const PaymentEvent();
}

class StartPayment extends PaymentEvent {
  const StartPayment({
    required this.sessionUrl,
    required this.successUrl,
    required this.cancelUrl,
  });

  final String sessionUrl;
  final String successUrl;
  final String cancelUrl;
}

class PaymentSuccess extends PaymentEvent {
  const PaymentSuccess();
}

class PaymentCancelled extends PaymentEvent {
  const PaymentCancelled();
}

class PaymentFailed extends PaymentEvent {
  const PaymentFailed();
}

class ResetPayment extends PaymentEvent {
  const ResetPayment();
}