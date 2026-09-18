import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_response.g.dart';

@JsonSerializable()
class OrderResponse {
  final OrderDataModel? data;
  final int? statusCode;
  final bool? success;
  final String? message;
  final String? messageLocalized;

  const OrderResponse({
    this.data,
    this.statusCode,
    this.success,
    this.message,
    this.messageLocalized,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}

@JsonSerializable()
class OrderDataModel {
  final String? orderId;
  final String? orderNumber;
  final int? status;
  final int? paymentMethod;
  final int? paymentStatus;
  final bool? paymentRequired;
  final String? sessionUrl;
  final String? successUrl;
  final String? cancelUrl;
  final double? subtotal;
  final double? deliveryFee;
  final double? discount;
  final double? total;

  const OrderDataModel({
    this.orderId,
    this.orderNumber,
    this.status,
    this.paymentMethod,
    this.paymentStatus,
    this.paymentRequired,
    this.sessionUrl,
    this.successUrl,
    this.cancelUrl,
    this.subtotal,
    this.deliveryFee,
    this.discount,
    this.total,
  });

  factory OrderDataModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDataModelFromJson({
        ...json,
        'sessionUrl':
            json['sessionUrl'] ??
            json['paymentUrl'] ??
            json['checkoutUrl'] ??
            json['checkoutSessionUrl'],
        'successUrl': json['successUrl'] ?? json['success_url'],
        'cancelUrl': json['cancelUrl'] ?? json['cancel_url'],
      });

  Map<String, dynamic> toJson() => _$OrderDataModelToJson(this);

  OrderEntity toDomain() {
    return OrderEntity(
      orderId: orderId ?? '',
      orderNumber: orderNumber ?? '',
      status: status,
      paymentMethod: paymentMethod ?? 1,
      paymentStatus: paymentStatus ?? 0,
      paymentRequired: paymentRequired,
      sessionUrl: sessionUrl,
      successUrl: successUrl,
      cancelUrl: cancelUrl,
      subtotal: subtotal ?? 0,
      deliveryFee: deliveryFee ?? 0,
      discount: discount ?? 0,
      total: total ?? 0,
    );
  }
}
