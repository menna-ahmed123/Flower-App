import 'dart:convert';

import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'checkout_preview_response.g.dart';

@JsonSerializable()
class CheckoutDetailsResponse {
  final Object? status;
  final int? code;
  final String? message;
  final CheckoutDetailsDataModel? data;
  final Object? pagination;
  final Object? errors;

  const CheckoutDetailsResponse({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory CheckoutDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckoutDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutDetailsResponseToJson(this);
}

@JsonSerializable()
class CheckoutDetailsDataModel {
  final String? cartId;
  final String? addressId;
  final bool? isServiceable;
  final double? subtotal;
  final double? deliveryFee;
  final double? total;
  final String? estimatedDeliveryAt;
  final List<CheckoutPaymentMethodModel>? paymentMethods;
  final bool? isGift;
  final String? giftRecipientName;
  final String? giftRecipientPhone;

  const CheckoutDetailsDataModel({
    this.cartId,
    this.addressId,
    this.isServiceable,
    this.subtotal,
    this.deliveryFee,
    this.total,
    this.estimatedDeliveryAt,
    this.paymentMethods,
    this.isGift,
    this.giftRecipientName,
    this.giftRecipientPhone,
  });

  factory CheckoutDetailsDataModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutDetailsDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutDetailsDataModelToJson(this);

  CartEntity toDomain() {
    return CartEntity(
      id: cartId ?? '',
      items: const [],
      subtotal: subtotal ?? 0,
      deliveryFee: deliveryFee ?? 0,
      total: total ?? 0,
      itemCount: 0,
      isServiceable: isServiceable ?? true,
      estimatedDeliveryAt: estimatedDeliveryAt,
      paymentMethods: [
        for (final method in paymentMethods ?? const [])
          if ((method.method ?? '').trim().isNotEmpty) method.toDomain(),
      ],
    );
  }
}

@JsonSerializable()
class CheckoutPaymentMethodModel {
  final String? method;
  final List<String>? gateways;

  const CheckoutPaymentMethodModel({this.method, this.gateways});

  factory CheckoutPaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutPaymentMethodModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutPaymentMethodModelToJson(this);

  PaymentMethodEntity toDomain() {
    final raw = (method ?? '').trim();
    return PaymentMethodEntity(
      name: _displayMethod(raw),
      apiMethod: _requestMethod(raw),
      gateway: _gateway(gateways),
    );
  }
}

@JsonSerializable()
class EstimateDeliveryResponse {
  final Object? status;
  final int? code;
  final String? message;
  final Map<String, dynamic>? data;
  final Object? pagination;
  final Object? errors;

  const EstimateDeliveryResponse({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory EstimateDeliveryResponse.fromJson(Map<String, dynamic> json) =>
      _$EstimateDeliveryResponseFromJson(json);

  factory EstimateDeliveryResponse.parse(Object? body) {
    final json = _estimateJson(body);
    if (json == null) return const EstimateDeliveryResponse();
    return EstimateDeliveryResponse.fromJson(json);
  }

  Map<String, dynamic> toJson() => _$EstimateDeliveryResponseToJson(this);

  DeliveryEstimateEntity toDomain() {
    final payload = data;
    if (payload == null || payload.isEmpty) {
      return const DeliveryEstimateEntity();
    }
    return DeliveryEstimateEntity(
      subtotal: _nullableDouble(payload, 'subtotal'),
      deliveryFee: _nullableDouble(payload, 'deliveryFee'),
      total: _nullableDouble(payload, 'total'),
      estimatedDeliveryAt: payload['estimatedDeliveryAt'] as String?,
      isServiceable: payload['isServiceable'] as bool?,
      hasData: true,
      includesDeliveryAt: payload.containsKey('estimatedDeliveryAt'),
    );
  }
}

Map<String, dynamic>? _estimateJson(Object? body) {
  if (body is Map) {
    return body.map((key, value) => MapEntry(key.toString(), value));
  }
  if (body is! String || body.trim().isEmpty) return null;
  final decoded = jsonDecode(body);
  if (decoded is! Map) return null;
  return decoded.map((key, value) => MapEntry(key.toString(), value));
}

double? _nullableDouble(Map<String, dynamic> json, String key) {
  if (!json.containsKey(key) || json[key] == null) return null;
  final value = json[key];
  return value is num ? value.toDouble() : null;
}

String _displayMethod(String method) {
  return switch (method.toUpperCase()) {
    'COD' => AppString.cashOnDelivery,
    'CARD' => AppString.creditCard,
    _ => method,
  };
}

String _requestMethod(String method) {
  return switch (method.toUpperCase()) {
    'COD' => 'COD',
    'CARD' => 'CARD',
    _ => method,
  };
}

String? _gateway(List<String>? gateways) {
  if (gateways == null || gateways.isEmpty) return null;
  return gateways.first;
}
