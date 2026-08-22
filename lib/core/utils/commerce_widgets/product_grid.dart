import 'package:flower_app/core/utils/commerce_widgets/product_card.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.products});
  final List<ProductEntity> products;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
  padding: const EdgeInsets.all(16),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
childAspectRatio: 0.6,  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    final product = products[index];

  return ProductCard(
  imageUrl: product.imageUrl,
  name: product.name,
  price: product.discountedPrice.toStringAsFixed(2),
  oldPrice: product.price != product.discountedPrice
      ? product.price?.toStringAsFixed(2)
      : null,
  discount: product.discountPercent != null
      ? '${product.discountPercent!.toStringAsFixed(0)}%'
      : null,
  onAddToCart: () {},
  onTap: () {},
);
  },
);
  }
}