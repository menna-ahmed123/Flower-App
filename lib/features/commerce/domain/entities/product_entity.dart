import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final double? price;
  final double discountedPrice;
  final double? discountPercent;
  final bool inStock;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
     this.price,
    required this.discountedPrice,
    this.discountPercent,
    required this.inStock,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        price,
        discountedPrice,
        discountPercent,
        inStock,
      ];
}