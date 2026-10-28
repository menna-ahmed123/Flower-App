import 'package:flower_app/core/widgets/app_shimmer/shimmer_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shimmer skeleton for the Home screen.
/// Matches the real layout: header → banner → categories → best sellers → occasions.
class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmerEffect(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildBanner(),
            _buildSectionHeader(),
            _buildCategoryRail(),
            _buildSectionHeader(),
            _buildProductRail(),
            _buildSectionHeader(),
            _buildOccasionRail(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo row: icon + "Flowery" text
          Row(
            children: [
              ShimmerBox(width: 22.w, height: 22.w, borderRadius: 4.r),
              SizedBox(width: 6.w),
              ShimmerBox(width: 90.w, height: 22.h, borderRadius: 4.r),
            ],
          ),
          SizedBox(height: 12.h),
          // Search bar
          ShimmerBox(
            width: double.infinity,
            height: 44.h,
            borderRadius: 12.r,
          ),
          SizedBox(height: 12.h),
          // Delivery address row
          Row(
            children: [
              ShimmerBox(width: 18.w, height: 18.w, borderRadius: 4.r),
              SizedBox(width: 15.w),
              ShimmerBox(width: 180.w, height: 20.h, borderRadius: 4.r),
              const Spacer(),
              ShimmerBox(width: 20.w, height: 20.w, borderRadius: 4.r),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      child: AspectRatio(
        aspectRatio: 343 / 150,
        child: ShimmerBox(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 12.r,
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        children: [
          ShimmerBox(width: 120.w, height: 18.h, borderRadius: 4.r),
          const Spacer(),
          ShimmerBox(width: 55.w, height: 14.h, borderRadius: 4.r),
        ],
      ),
    );
  }

  Widget _buildCategoryRail() {
    return SizedBox(
      height: 96.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 5,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, __) => SizedBox(
          width: 72.w,
          child: Column(
            children: [
              ShimmerBox(width: 68.w, height: 68.w, borderRadius: 12.r),
              SizedBox(height: 6.h),
              ShimmerBox(width: 50.w, height: 12.h, borderRadius: 4.r),
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, __) => Container(
          width: 163.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Square image placeholder (AspectRatio ~1 within 147w content)
              ShimmerBox(
                width: double.infinity,
                height: 147.h,
                borderRadius: 4.r,
              ),
              SizedBox(height: 8.h),
              ShimmerBox(width: 120.w, height: 14.h, borderRadius: 4.r),
              SizedBox(height: 4.h),
              ShimmerBox(width: 80.w, height: 16.h, borderRadius: 4.r),
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, __) => SizedBox(
          width: 140.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: 140.w, height: 160.h, borderRadius: 8.r),
              SizedBox(height: 8.h),
              ShimmerBox(width: 90.w, height: 14.h, borderRadius: 4.r),
            ],
          ),
        ),
      ),
    );
  }
}
