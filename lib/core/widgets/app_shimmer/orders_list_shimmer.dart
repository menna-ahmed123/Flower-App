import 'package:flower_app/core/widgets/app_shimmer/shimmer_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersListShimmer extends StatelessWidget {
  const OrdersListShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return AppShimmerEffect(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            itemCount,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == itemCount - 1 ? 0 : 12.h,
              ),
              child: const OrderCardShimmer(),
            ),
          ),
        ),
      ),
    );
  }
}

class OrderCardShimmer extends StatelessWidget {
  const OrderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 128.w, height: 110.h, borderRadius: 10.r),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6.h),
                ShimmerBox(width: 90.w, height: 12.h, borderRadius: 4.r),
                SizedBox(height: 10.h),
                ShimmerBox(width: 60.w, height: 14.h, borderRadius: 4.r),
                SizedBox(height: 10.h),
                ShimmerBox(width: 110.w, height: 12.h, borderRadius: 4.r),
                SizedBox(height: 26.h),
                ShimmerBox(width: double.infinity, height: 34.h, borderRadius: 20.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
