import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceAndStatusRow extends StatelessWidget {
  const PriceAndStatusRow({required this.product});

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
