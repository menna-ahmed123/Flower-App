import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view/widgets/price_and_status_row.dart';
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
                PriceAndStatusRow(product: product),
                SizedBox(height: 4.h),
                Text(
                  AppString.allPricesIncludeTax,
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
                Text(
                  AppString.description,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.black,
                  ),
                ),
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
                Text(
                  AppString.bouquetInclude,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.black,
                  ),
                ),
                SizedBox(height: 6.h),
                ...(product.includedItems ?? const []).map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text(
                      item.quantity != null
                          ? '${item.name}: ${item.quantity}'
                          : item.name ?? '',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: context.colors.grey.shade800,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
