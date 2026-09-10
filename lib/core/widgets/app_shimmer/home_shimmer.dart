import 'package:flower_app/core/widgets/app_shimmer/shimmer_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shimmer skeleton for the Home screen.
class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmerEffect(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            _buildHeader(),
            SizedBox(height: 20.h),
            _buildSectionHeader(),
            SizedBox(height: 12.h),
            _buildCategoryRail(),
            SizedBox(height: 20.h),
            _buildSectionHeader(),
            SizedBox(height: 12.h),
            _buildProductRail(),
            SizedBox(height: 20.h),
            _buildSectionHeader(),
            SizedBox(height: 12.h),
            _buildOccasionRail(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShimmerBox(
              width: 24.w,
              height: 24.w,
              borderRadius: 4.r,
            ),
            SizedBox(width: 8.w),
            ShimmerBox(
              width: 90.w,
              height: 22.h,
              borderRadius: 4.r,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ShimmerBox(
          width: double.infinity,
          height: 44.h,
          borderRadius: 12.r,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            ShimmerBox(
              width: 18.w,
              height: 18.w,
              borderRadius: 4.r,
            ),
            SizedBox(width: 6.w),
            ShimmerBox(
              width: 180.w,
              height: 14.h,
              borderRadius: 4.r,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShimmerBox(
          width: 120.w,
          height: 18.h,
          borderRadius: 4.r,
        ),
        ShimmerBox(
          width: 55.w,
          height: 14.h,
          borderRadius: 4.r,
        ),
      ],
    );
  }

  Widget _buildCategoryRail() {
    return SizedBox(
      height: 96.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) => SizedBox(
          width: 72.w,
          child: Column(
            children: [
              ShimmerBox(
                width: 68.w,
                height: 68.w,
                borderRadius: 12.r,
              ),
              SizedBox(height: 6.h),
              ShimmerBox(
                width: 50.w,
                height: 12.h,
                borderRadius: 4.r,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductRail() {
    return SizedBox(
      height: 280.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) => SizedBox(
          width: 163.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(
                width: 163.w,
                height: 150.h,
                borderRadius: 10.r,
              ),
              SizedBox(height: 8.h),
              ShimmerBox(
                width: 120.w,
                height: 14.h,
                borderRadius: 4.r,
              ),
              SizedBox(height: 6.h),
              ShimmerBox(
                width: 80.w,
                height: 16.h,
                borderRadius: 4.r,
              ),
              SizedBox(height: 8.h),
              ShimmerBox(
                width: double.infinity,
                height: 36.h,
                borderRadius: 20.r,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOccasionRail() {
    return SizedBox(
      height: 196.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) => SizedBox(
          width: 140.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(
                width: 140.w,
                height: 160.h,
                borderRadius: 8.r,
              ),
              SizedBox(height: 8.h),
              ShimmerBox(
                width: 90.w,
                height: 14.h,
                borderRadius: 4.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}