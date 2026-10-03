import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_response.g.dart';

@JsonSerializable()
class CartResponse {
  final Object? status;
  final int? code;
  final String? message;
  final CartDataModel? data;
  final dynamic pagination;
  final dynamic errors;

  const CartResponse({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) =>
      _$CartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CartResponseToJson(this);
}

@JsonSerializable()
class CartDataModel {
  final String? cartId;
  final List<CartItemModel>? items;
  final int? totalQuantity;
  final int? lineCount;
  final double? subtotal;
  final double? deliveryFee;
  final double? total;
  final bool? hasChanges;

  const CartDataModel({
    this.cartId,
    this.items,
    this.totalQuantity,
    this.lineCount,
    this.subtotal,
    this.deliveryFee,
    this.total,
    this.hasChanges,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) =>
      _$CartDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartDataModelToJson(this);

  CartEntity toDomain() {
    final lines = [
      for (final item in items ?? const <CartItemModel>[]) item.toDomain(),
    ];
    final lineSum = CartEntity.sumLines(lines);
    return CartEntity(
      id: cartId ?? '',
      items: lines,
      subtotal: subtotal ?? lineSum,
      deliveryFee: deliveryFee ?? 0,
      total: total ?? (subtotal ?? lineSum) + (deliveryFee ?? 0),
      itemCount: totalQuantity ?? CartEntity.sumQuantities(lines),
      hasChanges: hasChanges ?? false,
    );
  }
}

@JsonSerializable()
class CartItemModel {
  final String? itemId;
  final String? productId;
  final String? productName;
  final String? productImage;
  final double? unitPrice;
  final double? priceAtAdd;
  final int? quantity;
  final double? lineSubtotal;
  final int? availableStock;
  final bool? isAvailable;
  final bool? priceChanged;
  final bool? stockChanged;

  const CartItemModel({
    this.itemId,
    this.productId,
    this.productName,
    this.productImage,
    this.unitPrice,
    this.priceAtAdd,
    this.quantity,
    this.lineSubtotal,
    this.availableStock,
    this.isAvailable,
    this.priceChanged,
    this.stockChanged,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(_cartItemJson(json));

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItemEntity toDomain() {
    final id = (itemId ?? '').isNotEmpty ? itemId! : (productId ?? '');
    return CartItemEntity(
      id: id,
      productId: productId ?? '',
      name: productName ?? '',
      imageUrl: ApiEndpoints.mediaUrl(productImage),
      price: unitPrice ?? 0,
      quantity: quantity ?? 1,
      stock: availableStock,
      priceChanged: priceChanged ?? false,
      outOfStock: isAvailable == false,
    );
  }
}

@JsonSerializable()
class AddCartItemRequest {
  final String productId;
  final int quantity;

  const AddCartItemRequest({required this.productId, this.quantity = 1});

  factory AddCartItemRequest.fromJson(Map<String, dynamic> json) =>
      _$AddCartItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddCartItemRequestToJson(this);
}

@JsonSerializable()
class AddCartItemResponse {
  final Object? status;
  final int? code;
  final String? message;
  final AddCartItemDataModel? data;
  final dynamic pagination;
  final dynamic errors;

  const AddCartItemResponse({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory AddCartItemResponse.fromJson(Map<String, dynamic> json) =>
      _$AddCartItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddCartItemResponseToJson(this);
}

@JsonSerializable()
class AddCartItemDataModel {
  final String? cartId;
  final String? itemId;
  final String? productId;
  final int? quantity;
  final double? priceAtAdd;

  const AddCartItemDataModel({
    this.cartId,
    this.itemId,
    this.productId,
    this.quantity,
    this.priceAtAdd,
  });

  factory AddCartItemDataModel.fromJson(Map<String, dynamic> json) =>
      _$AddCartItemDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddCartItemDataModelToJson(this);
}

@JsonSerializable()
class UpdateCartItemRequest {
  final int quantity;

  const UpdateCartItemRequest({required this.quantity});

  factory UpdateCartItemRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCartItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCartItemRequestToJson(this);
}

Map<String, dynamic> _cartItemJson(Map<String, dynamic> json) {
  return {
    'itemId': json['itemId'] ?? json['id'],
    'productId': json['productId'],
    'productName': json['productName'] ?? json['name'],
    'productImage': json['productImage'] ?? json['imageUrl'],
    'unitPrice': json['unitPrice'] ?? json['price'],
    'priceAtAdd': json['priceAtAdd'],
    'quantity': json['quantity'],
    'lineSubtotal': json['lineSubtotal'],
    'availableStock':
        json['availableStock'] ?? json['availableQuantity'] ?? json['stock'],
    'isAvailable': _itemAvailable(json),
    'priceChanged': json['priceChanged'],
    'stockChanged': json['stockChanged'],
  };
}

bool? _itemAvailable(Map<String, dynamic> json) {
  final available = json['isAvailable'];
  if (available is bool) return available;
  final inStock = json['inStock'];
  if (inStock is bool) return inStock;
  if (json['outOfStock'] == true) return false;
  return null;
}
