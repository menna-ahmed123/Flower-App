import 'package:flower_app/features/address/domain/entities/address_entity.dart';

sealed class CheckoutEvent {}

class LoadCheckoutPreview extends CheckoutEvent {}

class SelectCheckoutAddress extends CheckoutEvent {
  SelectCheckoutAddress(this.address);

  final AddressEntity address;
}

class ToggleCheckoutGift extends CheckoutEvent {
  ToggleCheckoutGift(this.enabled);

  final bool enabled;
}

class UpdateGiftRecipient extends CheckoutEvent {
  UpdateGiftRecipient({this.name, this.phone});

  final String? name;
  final String? phone;
}

class SelectCheckoutPayment extends CheckoutEvent {
  SelectCheckoutPayment(this.method);

  final String method;
}

class SubmitPlaceOrder extends CheckoutEvent {}

class ProcessCheckoutPayment extends CheckoutEvent {}

class ClearCheckoutNavigation extends CheckoutEvent {}
