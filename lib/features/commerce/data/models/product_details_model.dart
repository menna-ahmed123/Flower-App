import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'included_item_model.dart';

part 'product_details_model.g.dart';

@JsonSerializable()
class ProductDetailsModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'imageUrls')
  final List<String>? imageUrls;

  @JsonKey(name: 'includedItems')
  final List<IncludedItemModel>? includedItems;

  @JsonKey(name: 'price')
  final double? price;

  @JsonKey(name: 'discountedPrice')
  final double? discountedPrice;

  @JsonKey(name: 'discountPercent')
  final double? discountPercent;

  @JsonKey(name: 'requiresStoreSelection')
  final bool? requiresStoreSelection;

  @JsonKey(name: 'inStock')
  final bool? inStock;

  @JsonKey(name: 'availableQuantity')
  final int? availableQuantity;

  const ProductDetailsModel({
    this.id,
    this.name,
    this.description,
    this.imageUrls,
    this.includedItems,
    this.price,
    this.discountedPrice,
    this.discountPercent,
    this.requiresStoreSelection,
    this.inStock,
    this.availableQuantity,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return _$ProductDetailsModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ProductDetailsModelToJson(this);
  }

  ProductDetailsEntity toDomain() {
    return ProductDetailsEntity(
      id: id,
      name: name,
      description: description,
      imageUrls: imageUrls?.map(ApiEndpoints.mediaUrl).toList(),
      includedItems: includedItems?.map((item) => item.toDomain()).toList(),
      price: price,
      discountedPrice: discountedPrice,
      discountPercent: discountPercent,
      requiresStoreSelection: requiresStoreSelection,
      inStock: inStock,
      availableQuantity: availableQuantity,
    );
  }
}
