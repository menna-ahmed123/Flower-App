import 'package:flower_app/core/widgets/app_shimmer/product_grid_shimmer.dart';
import 'package:flower_app/core/widgets/app_shimmer/shimmer_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shimmer skeleton for the Category screen.
class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmerEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabBarSkeleton(),
          SizedBox(height: 16.h),
          const Expanded(child: ProductGridShimmer(padding: EdgeInsets.zero)),
        ],
      ),
    );
  }

  Widget _buildTabBarSkeleton() {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 4,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) =>
            ShimmerBox(width: 80.w, height: 36.h, borderRadius: 20.r),
      ),
    );
  }
}
