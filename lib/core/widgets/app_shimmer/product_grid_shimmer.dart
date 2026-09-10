import 'package:flower_app/core/widgets/app_shimmer/shimmer_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A shared shimmer grid for products.
class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({
    super.key,
    this.itemCount = 6,
    this.physics = const NeverScrollableScrollPhysics(),
    this.padding = const EdgeInsets.all(16),
  });

  final int itemCount;
  final ScrollPhysics physics;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 13.h,
        childAspectRatio: 0.55,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade200, width: 1.w),
      ),
      padding: EdgeInsets.all(8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: ShimmerBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 4.r,
            ),
          ),
          SizedBox(height: 8.h),
          ShimmerBox(width: 100.w, height: 14.h, borderRadius: 4.r),
          SizedBox(height: 6.h),
          ShimmerBox(width: 70.w, height: 16.h, borderRadius: 4.r),
          SizedBox(height: 8.h),
          ShimmerBox(width: double.infinity, height: 34.h, borderRadius: 20.r),
        ],
      ),
    );
  }
}
