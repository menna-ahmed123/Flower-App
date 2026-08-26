import 'package:flower_app/features/commerce/core/widgets/product_card.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.onTap,
  });

  final List<ProductEntity> products;
  final void Function(ProductEntity product) onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 13.h,
        childAspectRatio: 0.55,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return ProductCard(
          imageUrl: product.imageUrl,
          name: product.name,
          price: product.discountedPrice > 0
              ? product.discountedPrice.toStringAsFixed(2)
              : 'N/A',
          oldPrice: product.price != product.discountedPrice
              ? product.price?.toStringAsFixed(2)
              : null,
          discount: product.discountPercent != null
              ? '${product.discountPercent!.toStringAsFixed(0)}%'
              : null,
          onAddToCart: () {},
          onTap: () => onTap(product),
        );
      },
    );
  }
}