import 'package:flower_app/features/address/data/models/address_dto.dart';
import 'package:flower_app/features/cart/data/models/cart_response.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'checkout_preview_response.g.dart';

@JsonSerializable()
class CheckoutPreviewResponse {
  final CheckoutPreviewDataModel? data;
  final int? statusCode;
  final bool? success;
  final String? message;
  final String? messageLocalized;

  const CheckoutPreviewResponse({
    this.data,
    this.statusCode,
    this.success,
    this.message,
    this.messageLocalized,
  });

  factory CheckoutPreviewResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckoutPreviewResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutPreviewResponseToJson(this);
}

@JsonSerializable()
class CheckoutPreviewDataModel {
  final String? id;
  final List<CartItemModel>? items;
  final double? subtotal;
  final double? total;
  final double? deliveryFee;
  final double? discount;
  final int? itemsCount;
  @JsonKey(fromJson: _deliveryAddressFromJson)
  final AddressDto? deliveryAddress;
  @JsonKey(fromJson: _paymentMethodsFromJson)
  final List<PaymentMethodModel>? paymentMethods;

  const CheckoutPreviewDataModel({
    this.id,
    this.items,
    this.subtotal,
    this.total,
    this.deliveryFee,
    this.discount,
    this.itemsCount,
    this.deliveryAddress,
    this.paymentMethods,
  });

  factory CheckoutPreviewDataModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutPreviewDataModelFromJson(_normalizePreviewJson(json));

  Map<String, dynamic> toJson() => _$CheckoutPreviewDataModelToJson(this);

  CartEntity toDomain() {
    final cartItems = items ?? [];
    final lines = [for (final item in cartItems) item.toDomain()];
    return CartEntity(
      id: id ?? '',
      items: lines,
      subtotal: subtotal ?? 0,
      deliveryFee: deliveryFee ?? 0,
      discount: discount ?? 0,
      total: total ?? 0,
      itemCount: itemsCount ?? CartEntity.sumQuantities(lines),
      deliveryAddress: deliveryAddress?.toDomain(),
      paymentMethods: [
        for (final method in paymentMethods ?? const <PaymentMethodModel>[])
          method.toDomain(),
      ],
    );
  }
}

@JsonSerializable()
class PaymentMethodModel {
  final String? name;
  final String? label;
  final int? id;
  final int? paymentMethod;
  final int? value;

  const PaymentMethodModel({
    this.name,
    this.label,
    this.id,
    this.paymentMethod,
    this.value,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);

  PaymentMethodEntity toDomain() {
    final resolvedName = (name ?? label ?? '').trim();
    return PaymentMethodEntity(
      name: resolvedName,
      value: id ?? paymentMethod ?? value ?? _paymentValue(resolvedName),
    );
  }
}

Map<String, dynamic> _normalizePreviewJson(Map<String, dynamic> json) {
  return {
    ...json,
    'items': json['items'] ?? json['lines'],
    'itemsCount': json['itemsCount'] ?? json['itemCount'],
  };
}

AddressDto? _deliveryAddressFromJson(Object? value) {
  if (value is! Map || value.isEmpty) return null;
  final json = value.map((key, nested) => MapEntry(key.toString(), nested));
  return AddressDto.fromJson({...json, 'id': json['id'] ?? json['addressId']});
}

List<PaymentMethodModel>? _paymentMethodsFromJson(Object? value) {
  if (value is! List) return null;
  return [for (final item in value) ?_paymentMethodModel(item)];
}

PaymentMethodModel? _paymentMethodModel(Object? item) {
  if (item is String && item.trim().isNotEmpty) {
    return PaymentMethodModel(name: item);
  }
  if (item is! Map) return null;
  final model = PaymentMethodModel.fromJson(
    item.map((key, nested) => MapEntry(key.toString(), nested)),
  );
  final name = (model.name ?? model.label ?? '').trim();
  return name.isEmpty ? null : model;
}

int _paymentValue(String name) {
  final normalized = name.toLowerCase();
  if (normalized.contains('card') || normalized.contains('credit')) return 2;
  return 1;
}
