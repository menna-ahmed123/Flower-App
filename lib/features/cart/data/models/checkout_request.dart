import 'package:json_annotation/json_annotation.dart';

part 'checkout_request.g.dart';

@JsonSerializable(explicitToJson: true)
class GiftRecipientRequest {
  final String recipientName;
  final String recipientPhone;

  const GiftRecipientRequest({
    required this.recipientName,
    required this.recipientPhone,
  });

  factory GiftRecipientRequest.fromJson(Map<String, dynamic> json) =>
      _$GiftRecipientRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GiftRecipientRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PlaceOrderRequest {
  final String cartId;
  final String addressId;
  final bool isGift;
  final GiftRecipientRequest? giftRecipient;
  final String paymentMethod;
  final String? paymentGateway;

  const PlaceOrderRequest({
    required this.cartId,
    required this.addressId,
    required this.isGift,
    required this.giftRecipient,
    required this.paymentMethod,
    required this.paymentGateway,
  });

  factory PlaceOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$PlaceOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceOrderRequestToJson(this);
}

@JsonSerializable()
class PaymentCheckoutRequest {
  final String orderId;
  final double amountTotal;
  final String currency;

  const PaymentCheckoutRequest({
    required this.orderId,
    required this.amountTotal,
    required this.currency,
  });

  factory PaymentCheckoutRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentCheckoutRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentCheckoutRequestToJson(this);
}
