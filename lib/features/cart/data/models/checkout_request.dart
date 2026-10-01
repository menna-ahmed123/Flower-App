import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'checkout_request.g.dart';

@JsonSerializable(includeIfNull: false)
class CheckoutGiftRequest {
  final String recipientName;
  final String phone;
  final String addressLine;
  final String city;
  final String area;
  final double? lat;
  final double? lng;
  final String? message;

  const CheckoutGiftRequest({
    required this.recipientName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.area,
    this.lat,
    this.lng,
    this.message,
  });

  factory CheckoutGiftRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckoutGiftRequestFromJson(json);

  factory CheckoutGiftRequest.fromEntity(CheckoutGiftEntity gift) {
    return CheckoutGiftRequest(
      recipientName: gift.recipientName,
      phone: gift.phone,
      addressLine: gift.addressLine,
      city: gift.city,
      area: gift.area,
      lat: gift.lat,
      lng: gift.lng,
      message: gift.message,
    );
  }

  Map<String, dynamic> toJson() => _$CheckoutGiftRequestToJson(this);
}

@JsonSerializable(includeIfNull: false)
class CheckoutRequest {
  final String? addressId;
  final CheckoutGiftRequest? gift;
  final int? paymentMethod;
  final double? expectedTotal;

  const CheckoutRequest({
    this.addressId,
    this.gift,
    this.paymentMethod,
    this.expectedTotal,
  });

  factory CheckoutRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckoutRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutRequestToJson(this);
}
