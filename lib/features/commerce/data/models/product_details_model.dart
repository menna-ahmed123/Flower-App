import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_details_model.g.dart';

/// Product detail data as returned by GET /api/catalog/products/{id} (new API).
/// Key changes from old API:
///   - imageUrls  → images
///   - includedItems (`List<IncludedItemModel>`) → includes (`List<String>`)
///   - availableQuantity → availableStock
///   - added: availabilityStatus, categoryIds, occasionIds
@JsonSerializable()
class ProductDetailsModel {
  const ProductDetailsModel({
    this.id,
    this.name,
    this.description,
    this.images,
    this.includes,
    this.price,
    this.discountedPrice,
    this.discountPercent,
    this.inStock,
    this.availabilityStatus,
    this.availableStock,
    this.categoryIds,
    this.occasionIds,
    this.createdAt,
    this.updatedAt,
    this.lastChangedBy,
  });

  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'description')
  final String? description;

  /// New field name (was: imageUrls).
  @JsonKey(name: 'images')
  final List<String>? images;

  /// New format: flat list of strings like ["Pink roses: 15", "White wrap"].
  /// Old API had `List<IncludedItemModel>` with name+quantity.
  @JsonKey(name: 'includes')
  final List<String>? includes;

  @JsonKey(name: 'price')
  final double? price;

  @JsonKey(name: 'discountedPrice')
  final double? discountedPrice;

  @JsonKey(name: 'discountPercent')
  final double? discountPercent;

  @JsonKey(name: 'inStock')
  final bool? inStock;

  /// e.g. "IN_STOCK", "OUT_OF_STOCK"
  @JsonKey(name: 'availabilityStatus')
  final String? availabilityStatus;

  /// New field name (was: availableQuantity).
  @JsonKey(name: 'availableStock')
  final int? availableStock;

  @JsonKey(name: 'categoryIds')
  final List<String>? categoryIds;

  @JsonKey(name: 'occasionIds')
  final List<String>? occasionIds;

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  @JsonKey(name: 'lastChangedBy')
  final String? lastChangedBy;

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailsModelToJson(this);

  ProductDetailsEntity toDomain() {
    return ProductDetailsEntity(
      id: id,
      name: name,
      description: description,
      imageUrls: images?.map(ApiEndpoints.mediaUrl).toList(),
      // Convert List<String> includes → List<IncludedItemEntity> for backward compat
      includedItems: null,
      includesRaw: includes,
      price: price,
      discountedPrice: discountedPrice,
      discountPercent: discountPercent,
      requiresStoreSelection: null,
      inStock: inStock,
      availableQuantity: availableStock,
      availabilityStatus: availabilityStatus,
    );
  }
}
