import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_response.g.dart';

@JsonSerializable()
class OrderResponse {
  final Object? status;
  final int? code;
  final String? message;
  final OrderDataModel? data;
  final Object? pagination;
  final Object? errors;

  const OrderResponse({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}

@JsonSerializable()
class OrderDataModel {
  final String? orderId;
  final String? orderNumber;
  final String? status;
  final String? paymentStatus;
  final String? paymentMethod;
  final double? subtotal;
  final double? deliveryFee;
  final double? total;
  final String? gateway;
  final String? sessionId;
  final String? sessionUrl;
  final double? amount;
  final String? currency;
  final String? successUrl;
final String? cancelUrl;

  const OrderDataModel({
    this.orderId,
    this.orderNumber,
    this.status,
    this.paymentStatus,
    this.paymentMethod,
    this.subtotal,
    this.deliveryFee,
    this.total,
    this.gateway,
    this.sessionId,
    this.sessionUrl,
    this.amount,
    this.currency,
    this.successUrl,
    this.cancelUrl,
  });

  factory OrderDataModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDataModelToJson(this);

  OrderEntity toDomain() {
    return OrderEntity(
      orderId: orderId ?? '',
      orderNumber: orderNumber ?? '',
      status: status,
      paymentMethod: paymentMethod ?? gateway ?? '',
      paymentStatus: paymentStatus ?? '',
      subtotal: subtotal ?? 0,
      deliveryFee: deliveryFee ?? 0,
      total: total ?? amount ?? 0,
      sessionUrl: sessionUrl ?? '',
      stripeSessionId: sessionId ?? '',
      currency: currency ?? '',
      successUrl: successUrl ?? '',
      cancelUrl: cancelUrl ?? '',
    );
  }
}

@JsonSerializable()
class PaymentCheckoutResponse {
  final PaymentCheckoutValue? value;
  final bool? isSuccess;
  final bool? isFailure;
  final PaymentCheckoutError? error;

  const PaymentCheckoutResponse({
    this.value,
    this.isSuccess,
    this.isFailure,
    this.error,
  });

  factory PaymentCheckoutResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentCheckoutResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentCheckoutResponseToJson(this);
}

@JsonSerializable()
class PaymentCheckoutValue {
  final String? checkoutUrl;
  final String? stripeSessionId;
  final String? paymentAttemptId;

  const PaymentCheckoutValue({
    this.checkoutUrl,
    this.stripeSessionId,
    this.paymentAttemptId,
  });

  factory PaymentCheckoutValue.fromJson(Map<String, dynamic> json) =>
      _$PaymentCheckoutValueFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentCheckoutValueToJson(this);
}

@JsonSerializable()
class PaymentCheckoutError {
  final String? code;
  final String? message;

  const PaymentCheckoutError({this.code, this.message});

  factory PaymentCheckoutError.fromJson(Map<String, dynamic> json) =>
      _$PaymentCheckoutErrorFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentCheckoutErrorToJson(this);
}
