import 'package:equatable/equatable.dart';

import 'included_item_entity.dart';

class ProductDetailsEntity extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final List<String>? imageUrls;
  final List<IncludedItemEntity>? includedItems;
  final double? price;
  final double? discountedPrice;
  final double? discountPercent;
  final bool? requiresStoreSelection;
  final bool? inStock;
  final int? availableQuantity;

  const ProductDetailsEntity({
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

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrls,
    includedItems,
    price,
    discountedPrice,
    discountPercent,
    requiresStoreSelection,
    inStock,
    availableQuantity,
  ];
}

