import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view/widgets/product_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ProductDetailsBody extends StatelessWidget {
  const ProductDetailsBody({super.key, required this.product});

  final ProductDetailsEntity product;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ProductImageSlider(imageUrls: product.imageUrls ?? const []),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PriceAndStatusRow(product: product),
                SizedBox(height: 4.h),
                Text(
                  'All prices include tax',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: context.colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  product.name ?? '',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.black,
                  ),
                ),
                SizedBox(height: 20.h),
                const _SectionTitle(title: 'Description'),
                SizedBox(height: 6.h),
                Text(
                  product.description ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.5,
                    color: context.colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 20.h),
                const _SectionTitle(title: 'Bouquet include'),
                SizedBox(height: 6.h),
                ...(product.includedItems ?? const []).map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text(
                      item.quantity != null
                          ? '${item.name}:${item.quantity}'
                          : item.name ?? '',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: context.colors.grey.shade800,
                      ),
                    ),
                  ),
                ),
                // extra space so content doesn't hide behind the fixed
                // "Add to cart" footer sitting in the Scaffold.
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceAndStatusRow extends StatelessWidget {
  const _PriceAndStatusRow({required this.product});

  final ProductDetailsEntity product;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final double price = product.price ?? 0;
    final double discountedPrice = product.discountedPrice ?? price;
    final bool hasDiscount = (product.discountPercent ?? 0) > 0;
    final bool inStock = product.inStock ?? false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'EGP ${hasDiscount ? discountedPrice : price}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: colors.black,
              ),
            ),
            if (hasDiscount) ...[
              SizedBox(width: 8.w),
              Text(
                'EGP $price',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: colors.grey.shade600,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),
        Text(
          'Status: ${inStock ? 'In stock' : 'Out of stock'}',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: inStock ? colors.green : colors.error,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: context.colors.black,
      ),
    );
  }
}
