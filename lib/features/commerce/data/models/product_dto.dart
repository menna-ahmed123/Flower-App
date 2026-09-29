import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

/// Single product item as returned inside GET /api/catalog/products data array.
@JsonSerializable()
class ProductDto {
  const ProductDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.price,
    this.discountPercentage,
    this.discountPrice,
    required this.inStock,
    this.categoryId,
    this.categoryName,
    this.createdAt,
  });

  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'imageUrl', defaultValue: '')
  final String imageUrl;

  @JsonKey(name: 'price')
  final double? price;

  /// New API field name (was: discountPercent).
  @JsonKey(name: 'discountPercentage')
  final double? discountPercentage;

  /// New API field name (was: discountedPrice).
  @JsonKey(name: 'discountPrice')
  final double? discountPrice;

  @JsonKey(name: 'inStock', defaultValue: true)
  final bool inStock;

  @JsonKey(name: 'categoryId')
  final String? categoryId;

  @JsonKey(name: 'categoryName')
  final String? categoryName;

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);

  ProductEntity toDomain() {
    return ProductEntity(
      id: id,
      name: name,
      imageUrl: ApiEndpoints.mediaUrl(imageUrl),
      price: price ?? 0,
      discountedPrice: discountPrice ?? price ?? 0,
      discountPercent: discountPercentage ?? 0,
      inStock: inStock,
    );
  }

  /// Converts to a raw map for home section rail items.
  Map<String, dynamic> toJson$HomeRail() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'discountedPrice': discountPrice,
        'discountPercent': discountPercentage,
      };
}
