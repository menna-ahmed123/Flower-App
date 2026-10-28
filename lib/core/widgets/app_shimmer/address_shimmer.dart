import 'package:flower_app/core/widgets/app_shimmer/shimmer_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shimmer skeleton for the Saved Address screen.
class AddressShimmer extends StatelessWidget {
  const AddressShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmerEffect(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
        itemCount: 4,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (_, _) => _addressCardSkeleton(),
      ),
    );
  }

  Widget _addressCardSkeleton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10.r,
            spreadRadius: 1.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          ShimmerBox(width: 24.w, height: 24.w, borderRadius: 4.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 100.w, height: 16.h, borderRadius: 4.r),
                SizedBox(height: 4.h),
                ShimmerBox(width: 180.w, height: 13.h, borderRadius: 4.r),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          ShimmerBox(width: 22.w, height: 22.w, borderRadius: 4.r),
          SizedBox(width: 12.w),
          ShimmerBox(width: 22.w, height: 22.w, borderRadius: 4.r),
        ],
      ),
    );
  }
}
