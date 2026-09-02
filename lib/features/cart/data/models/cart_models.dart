import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/api_query_params.dart';
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
  final int? itemsCount;

  const CartDataModel({
    this.id,
    this.items,
    this.subtotal,
    this.total,
    this.deliveryFee,
    this.itemsCount,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) =>
      _$CartDataModelFromJson(_normalizeCartDataJson(json));

  Map<String, dynamic> toJson() => _$CartDataModelToJson(this);

  CartEntity toDomain() {
    final lines = [
      for (final item in items ?? const <CartItemModel>[]) item.toDomain(),
    ];
    return CartEntity(
      id: id ?? '',
      items: lines,
      subtotal: subtotal ?? CartEntity.sumLines(lines),
      deliveryFee: deliveryFee ?? 0,
      total: total ?? (subtotal ?? CartEntity.sumLines(lines)) + (deliveryFee ?? 0),
      itemCount: itemsCount ?? CartEntity.sumQuantities(lines),
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
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItemEntity toDomain() {
    return CartItemEntity(
      id: id ?? '',
      productId: productId ?? '',
      name: name ?? productName ?? '',
      imageUrl: ApiEndpoints.mediaUrl(imageUrl),
      attributes: attributes,
      price: price ?? unitPrice ?? 0,
      quantity: quantity ?? 1,
      stock: availableQuantity ?? stock,
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

Map<String, dynamic> _normalizeCartDataJson(Map<String, dynamic> json) {
  return {
    ...json,
    'items': json['items'] ?? json['lines'],
    'itemsCount': json['itemsCount'] ?? json['itemCount'],
  };
}
