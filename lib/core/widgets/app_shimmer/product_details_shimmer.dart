import 'package:flower_app/core/widgets/app_shimmer/shimmer_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shimmer skeleton for the Product Details screen.
class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmerEffect(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(
              width: double.infinity,
              height: 300.h,
              borderRadius: 12.r,
            ),
            SizedBox(height: 16.h),
            ShimmerBox(width: 200.w, height: 22.h, borderRadius: 4.r),
            SizedBox(height: 12.h),
            Row(
              children: [
                ShimmerBox(width: 100.w, height: 20.h, borderRadius: 4.r),
                SizedBox(width: 12.w),
                ShimmerBox(width: 70.w, height: 16.h, borderRadius: 4.r),
              ],
            ),
            SizedBox(height: 16.h),
            ShimmerBox(width: double.infinity, height: 1.h, borderRadius: 0),
            SizedBox(height: 16.h),
            ShimmerBox(width: 120.w, height: 18.h, borderRadius: 4.r),
            SizedBox(height: 12.h),
            ShimmerBox(width: double.infinity, height: 14.h, borderRadius: 4.r),
            SizedBox(height: 8.h),
            ShimmerBox(width: double.infinity, height: 14.h, borderRadius: 4.r),
            SizedBox(height: 8.h),
            ShimmerBox(width: 250.w, height: 14.h, borderRadius: 4.r),
            SizedBox(height: 24.h),
            ShimmerBox(width: 80.w, height: 16.h, borderRadius: 4.r),
            SizedBox(height: 10.h),
            Row(
              children: List.generate(
                3,
                (_) => Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: ShimmerBox(
                    width: 48.w,
                    height: 48.w,
                    borderRadius: 24.r,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
