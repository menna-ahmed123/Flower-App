import 'package:flower_app/features/commerce/core/widgets/product_card.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.onTap,
    this.onAddToCart,
  });

  final List<ProductEntity> products;
  final void Function(ProductEntity) onTap;
  final void Function(String productId)? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.6,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return ProductCard(
          productId: product.id,
          imageUrl: product.imageUrl,
          name: product.name,
          price: product.discountedPrice.toStringAsFixed(2),
          oldPrice: product.price != product.discountedPrice
              ? product.price?.toStringAsFixed(2)
              : null,
          discount: product.discountPercent != null
              ? '${product.discountPercent!.toStringAsFixed(0)}%'
              : null,
          onAddToCart: () async {
            onAddToCart?.call(product.id);
          },
          onTap: () => onTap(product),
        );
      },
    );
  }
}
