import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoDriverMapBanner extends StatelessWidget {
  const NoDriverMapBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: context.colors.black.withValues(alpha: 0.26),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_top, size: 14, color: context.colors.warning),
          SizedBox(width: 6.w),
          Text(AppString.waitingForDriver, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
