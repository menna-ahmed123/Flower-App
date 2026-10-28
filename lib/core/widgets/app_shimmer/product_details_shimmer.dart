import 'package:flower_app/core/widgets/app_shimmer/shimmer_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shimmer skeleton for the Product Details screen.
class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmerEffect(
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ShimmerBox(
              width: double.infinity,
              height: 380.h,
              borderRadius: 0,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ShimmerBox(
                            width: 96.w,
                            height: 22.h,
                            borderRadius: 4.r,
                          ),
                          SizedBox(width: 8.w),
                          ShimmerBox(
                            width: 60.w,
                            height: 16.h,
                            borderRadius: 4.r,
                          ),
                        ],
                      ),
                      ShimmerBox(width: 90.w, height: 14.h, borderRadius: 4.r),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  ShimmerBox(width: 110.w, height: 12.h, borderRadius: 4.r),
                  SizedBox(height: 12.h),
                  ShimmerBox(width: 180.w, height: 20.h, borderRadius: 4.r),
                  SizedBox(height: 20.h),
                  ShimmerBox(width: 100.w, height: 15.h, borderRadius: 4.r),
                  SizedBox(height: 6.h),
                  ShimmerBox(
                    width: double.infinity,
                    height: 13.h,
                    borderRadius: 4.r,
                  ),
                  SizedBox(height: 8.h),
                  ShimmerBox(
                    width: double.infinity,
                    height: 13.h,
                    borderRadius: 4.r,
                  ),
                  SizedBox(height: 8.h),
                  ShimmerBox(width: 230.w, height: 13.h, borderRadius: 4.r),
                  SizedBox(height: 20.h),
                  ShimmerBox(width: 130.w, height: 15.h, borderRadius: 4.r),
                  SizedBox(height: 6.h),
                  ShimmerBox(width: 170.w, height: 13.h, borderRadius: 4.r),
                  SizedBox(height: 4.h),
                  ShimmerBox(width: 150.w, height: 13.h, borderRadius: 4.r),
                  SizedBox(height: 4.h),
                  ShimmerBox(width: 120.w, height: 13.h, borderRadius: 4.r),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
