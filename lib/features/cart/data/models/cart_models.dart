import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/api_query_params.dart';
import 'package:flower_app/features/address/data/models/address_dto.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_models.g.dart';

@JsonSerializable()
class CartResponse {
  final CartDataModel? data;
  final int? statusCode;
  final bool? success;
  final String? message;
  final String? messageLocalized;

  const CartResponse({
    this.data,
    this.statusCode,
    this.success,
    this.message,
    this.messageLocalized,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) =>
      _$CartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CartResponseToJson(this);
}

@JsonSerializable()
class CartDataModel {
  final String? id;
  final List<CartItemModel>? items;
  final double? subtotal;
  final double? total;
  final double? deliveryFee;
  final double? discount;
  final int? itemsCount;
  final bool? hasChanges;
  final bool? pricingUnavailable;
  final bool? isEmpty;
  @JsonKey(fromJson: _asStringKeyedMap)
  final Map<String, dynamic>? deliveryAddress;
  @JsonKey(fromJson: _asDynamicList)
  final List<dynamic>? paymentMethods;

  const CartDataModel({
    this.id,
    this.items,
    this.subtotal,
    this.total,
    this.deliveryFee,
    this.discount,
    this.itemsCount,
    this.hasChanges,
    this.pricingUnavailable,
    this.isEmpty,
    this.deliveryAddress,
    this.paymentMethods,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) =>
      _$CartDataModelFromJson(_normalizeCartDataJson(json));

  Map<String, dynamic> toJson() => _$CartDataModelToJson(this);

  CartEntity toDomain() {
    final cartItems = items ?? [];
    final lines = [for (final item in cartItems) item.toDomain()];
    return CartEntity(
      id: id ?? '',
      items: lines,
      subtotal: subtotal ?? CartEntity.sumLines(lines),
      deliveryFee: deliveryFee ?? 0,
      discount: discount ?? 0,
      total:
          total ??
          (subtotal ?? CartEntity.sumLines(lines)) + (deliveryFee ?? 0),
      itemCount: itemsCount ?? CartEntity.sumQuantities(lines),
      hasChanges: hasChanges ?? false,
      pricingUnavailable: pricingUnavailable ?? false,
    );
  }

  CartEntity toPreviewDomain() {
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
      deliveryAddress: _previewAddress(deliveryAddress),
      paymentMethods: _previewPaymentMethods(paymentMethods),
    );
  }
}

@JsonSerializable()
class CartItemModel {
  final String? id;
  final String? productId;
  final String? name;
  final String? productName;
  final String? imageUrl;
  final String? attributes;
  final double? price;
  final double? unitPrice;
  final int? quantity;
  final int? availableQuantity;
  final int? stock;
  final bool? priceChanged;
  final bool? outOfStock;
  final bool? inStock;

  const CartItemModel({
    this.id,
    this.productId,
    this.name,
    this.productName,
    this.imageUrl,
    this.attributes,
    this.price,
    this.unitPrice,
    this.quantity,
    this.availableQuantity,
    this.stock,
    this.priceChanged,
    this.outOfStock,
    this.inStock,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItemEntity toDomain() {
    return CartItemEntity(
      id: (id ?? '').isNotEmpty ? id! : (productId ?? ''),
      productId: productId ?? '',
      name: name ?? productName ?? '',
      imageUrl: ApiEndpoints.mediaUrl(imageUrl),
      attributes: attributes,
      price: price ?? unitPrice ?? 0,
      quantity: quantity ?? 1,
      stock: availableQuantity ?? stock,
      priceChanged: priceChanged ?? false,
      outOfStock: outOfStock ?? inStock == false,
    );
  }
}

@JsonSerializable()
class AddCartItemRequest {
  final String productId;
  final int quantity;
  final String storeId;

  const AddCartItemRequest({
    required this.productId,
    this.quantity = 1,
    this.storeId = ApiQueryParams.defaultStoreId,
  });

  factory AddCartItemRequest.fromJson(Map<String, dynamic> json) =>
      _$AddCartItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddCartItemRequestToJson(this);
}

@JsonSerializable()
class UpdateCartItemRequest {
  final int quantity;
  final String storeId;

  const UpdateCartItemRequest({
    required this.quantity,
    this.storeId = ApiQueryParams.defaultStoreId,
  });

  factory UpdateCartItemRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCartItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCartItemRequestToJson(this);
}

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

Map<String, dynamic> _normalizeCartDataJson(Map<String, dynamic> json) {
  return {
    ...json,
    'items': json['items'] ?? json['lines'],
    'itemsCount': json['itemsCount'] ?? json['itemCount'],
  };
}

Map<String, dynamic>? _asStringKeyedMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, nested) => MapEntry(key.toString(), nested));
  }
  return null;
}

AddressEntity? _previewAddress(Map<String, dynamic>? json) {
  if (json == null || json.isEmpty) return null;
  return AddressDto.fromJson({
    ...json,
    'id': json['id'] ?? json['addressId'],
  }).toDomain();
}

List<dynamic>? _asDynamicList(Object? value) {
  return value is List ? value : null;
}

List<PaymentMethodEntity> _previewPaymentMethods(List<dynamic>? raw) {
  if (raw == null || raw.isEmpty) return const [];
  final methods = <PaymentMethodEntity>[];
  for (final item in raw) {
    final method = _paymentMethod(item);
    if (method != null) methods.add(method);
  }
  return methods;
}

PaymentMethodEntity? _paymentMethod(dynamic item) {
  if (item is String && item.trim().isNotEmpty) {
    return PaymentMethodEntity(name: item, value: _paymentValue(item));
  }
  if (item is! Map) return null;
  final name = '${item['name'] ?? item['label'] ?? ''}'.trim();
  if (name.isEmpty) return null;
  final value =
      (item['id'] as num?)?.toInt() ??
      (item['paymentMethod'] as num?)?.toInt() ??
      (item['value'] as num?)?.toInt() ??
      _paymentValue(name);
  return PaymentMethodEntity(name: name, value: value);
}

int _paymentValue(String name) {
  final normalized = name.toLowerCase();
  if (normalized.contains('card') || normalized.contains('credit')) return 2;
  return 1;
}
