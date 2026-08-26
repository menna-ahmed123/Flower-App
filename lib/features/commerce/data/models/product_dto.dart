import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductDto {
  final String id;
  final String name;
  final String imageUrl;
  final double? price;
  final double? discountedPrice;
  final double? discountPercent;
  final bool inStock;

  const ProductDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.price,
    this.discountedPrice,
    this.discountPercent,
    required this.inStock,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);

  ProductEntity toDomain() {
    return ProductEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      price: price ?? 0,
      discountedPrice: discountedPrice ?? price ?? 0,
      discountPercent: discountPercent ?? 0,
      inStock: inStock,
    );
  }
}