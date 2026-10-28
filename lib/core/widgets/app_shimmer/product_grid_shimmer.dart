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
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.childAspectRatio = 0.6,
  });

  final int itemCount;
  final ScrollPhysics physics;
  final EdgeInsetsGeometry padding;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: crossAxisSpacing.w,
        mainAxisSpacing: mainAxisSpacing.h,
        childAspectRatio: childAspectRatio,
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
          AspectRatio(
            aspectRatio: 1,
            child: ShimmerBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 4.r,
            ),
          ),
          SizedBox(height: 8.h),
          ShimmerBox(width: 100.w, height: 14.h, borderRadius: 4.r),
          SizedBox(height: 4.h),
          Row(
            children: [
              ShimmerBox(width: 48.w, height: 16.h, borderRadius: 4.r),
              SizedBox(width: 8.w),
              ShimmerBox(width: 28.w, height: 13.h, borderRadius: 4.r),
              const Spacer(),
              ShimmerBox(width: 24.w, height: 13.h, borderRadius: 4.r),
            ],
          ),
          SizedBox(height: 8.h),
          ShimmerBox(width: double.infinity, height: 34.h, borderRadius: 20.r),
        ],
      ),
    );
  }
}
