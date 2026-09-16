import 'package:flower_app/core/widgets/app_shimmer/shimmer_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shimmer skeleton for the My Orders list screen.
class OrdersShimmer extends StatelessWidget {
  const OrdersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmerEffect(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
        itemCount: 4,
        itemBuilder: (context, index) => _OrderCardSkeleton(),
      ),
    );
  }
}

class _OrderCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(8.w),
      height: 125.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          ShimmerBox(width: 109.w, height: 109.h, borderRadius: 12.r),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(width: 90.w, height: 15.h),
                ShimmerBox(width: 70.w, height: 15.h),
                ShimmerBox(width: 120.w, height: 15.h),
                ShimmerBox(width: 150.w, height: 30.h, borderRadius: 20.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
