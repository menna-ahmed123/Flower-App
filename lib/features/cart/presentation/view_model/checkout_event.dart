import 'package:flower_app/features/address/domain/entities/address_entity.dart';

sealed class CheckoutEvent {
  const CheckoutEvent();
}

class LoadCheckoutPreview extends CheckoutEvent {
  const LoadCheckoutPreview();
}

class SelectCheckoutAddress extends CheckoutEvent {
  const SelectCheckoutAddress(this.address);

  final AddressEntity address;
}

class ToggleCheckoutGift extends CheckoutEvent {
  const ToggleCheckoutGift(this.enabled);

  final bool enabled;
}

class UpdateGiftRecipient extends CheckoutEvent {
  const UpdateGiftRecipient({this.name, this.phone});

  final String? name;
  final String? phone;
}

class SelectCheckoutPayment extends CheckoutEvent {
  const SelectCheckoutPayment(this.method);

  final String method;
}

class SubmitPlaceOrder extends CheckoutEvent {
  const SubmitPlaceOrder();
}

class ProcessCheckoutPayment extends CheckoutEvent {
  const ProcessCheckoutPayment();
}

class ClearCheckoutNavigation extends CheckoutEvent {
  const ClearCheckoutNavigation();
}
