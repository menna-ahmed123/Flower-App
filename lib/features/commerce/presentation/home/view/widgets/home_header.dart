import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, this.onQuery});

  final ValueChanged<String>? onQuery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _logo(context),
          SizedBox(height: 12.h),
          AppSearchField(onChanged: onQuery, onClear: () => onQuery?.call('')),
          SizedBox(height: 12.h),
          _deliverTo(context),
        ],
      ),
    );
  }

  Widget _logo(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(AppIcons.florist, color: colors.pink, size: 22.w),
        SizedBox(width: 6.w),
        Text(
          AppString.flowery,
          style: TextStyle(
            color: colors.pink,
            fontSize: 22.sp,
            fontFamily: 'serif',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _deliverTo(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(AppIcons.location, color: colors.black, size: 18.w),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            AppString.deliverTo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: colors.black, fontSize: 14.sp),
          ),
        ),
        Icon(AppIcons.keyboardArrowDown, color: colors.pink, size: 20.w),
      ],
    );
  }
}
