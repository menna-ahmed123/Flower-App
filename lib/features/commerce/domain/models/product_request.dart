import 'package:equatable/equatable.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';

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
// factory Product.fromEntity(ProductEntity product) {
//   return Product(
//     imageUrl: product.imageUrl,
//     name: product.name,
//     price: product.price.toString(),
//     oldPrice: product..toString(),
//     discount: product.discountPercent.toString(),
//     isOutOfStock: product.isOutOfStock,
//   );
// }
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
