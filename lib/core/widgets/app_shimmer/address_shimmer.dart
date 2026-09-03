import 'package:flower_app/core/widgets/app_shimmer/shimmer_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shimmer skeleton for the Saved Address screen.
class AddressShimmer extends StatelessWidget {
  const AddressShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmerEffect(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          children: [
            ...List.generate(
              4,
                  (_) =>
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: _addressCardSkeleton(),
              ),
            ),
            SizedBox(height: 16.h),
            ShimmerBox(
              width: double.infinity,
              height: 48.h,
              borderRadius: 24.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressCardSkeleton() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerBox.circle(size: 20.w),
              SizedBox(width: 8.w),
              ShimmerBox(
                width: 80.w,
                height: 16.h,
                borderRadius: 4.r,
              ),
              const Spacer(),
              ShimmerBox.circle(size: 20.w),
              SizedBox(width: 12.w),
              ShimmerBox.circle(size: 20.w),
            ],
          ),
          SizedBox(height: 16.h),
          ShimmerBox(
            width: 200.w,
            height: 14.h,
            borderRadius: 4.r,
          ),
        ],
      ),
    );
  }
}