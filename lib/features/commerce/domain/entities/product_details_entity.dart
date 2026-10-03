import 'package:equatable/equatable.dart';

import 'included_item_entity.dart';

class ProductDetailsEntity extends Equatable {
  const ProductDetailsEntity({
    this.id,
    this.name,
    this.description,
    this.imageUrls,
    this.includedItems,
    this.includesRaw,
    this.price,
    this.discountedPrice,
    this.discountPercent,
    this.requiresStoreSelection,
    this.inStock,
    this.availableQuantity,
    this.availabilityStatus,
  });

  final String? id;
  final String? name;
  final String? description;
  final List<String>? imageUrls;

  /// Old API: list of {name, quantity} objects (kept for backward compat).
  final List<IncludedItemEntity>? includedItems;

  /// New API: flat list of strings e.g. ["Pink roses: 15", "White wrap"].
  final List<String>? includesRaw;

  final double? price;
  final double? discountedPrice;
  final double? discountPercent;
  final bool? requiresStoreSelection;
  final bool? inStock;
  final int? availableQuantity;

  /// e.g. "IN_STOCK", "OUT_OF_STOCK"
  final String? availabilityStatus;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrls,
        includedItems,
        includesRaw,
        price,
        discountedPrice,
        discountPercent,
        requiresStoreSelection,
        inStock,
        availableQuantity,
        availabilityStatus,
      ];
}
