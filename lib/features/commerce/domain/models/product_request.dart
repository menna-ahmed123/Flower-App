import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String imageUrl;
  final String name;
  final String price;
  final String ?oldPrice;
  final String? discount;
  final bool isOutOfStock;

  const Product({
    required this.imageUrl,
    required this.name,
    required this.price,
     this.oldPrice,
     this.discount,
    this.isOutOfStock = false,
  });

  @override
  List<Object?> get props => [
    imageUrl,
    name,
    price,
    oldPrice,
    discount,
    isOutOfStock,
  ];
}
