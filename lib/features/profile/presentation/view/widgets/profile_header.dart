import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Top bar of the Profile screen: brand logo and the notifications entry point.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    this.notificationCount = 0,
    this.onNotificationTap,
  });

  /// Unread notifications count; the badge is hidden when this is zero.
  final int notificationCount;

  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLogo(context),
          _buildNotificationButton(context),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.lightPink,
            shape: BoxShape.circle,
          ),
          child: Icon(AppIcons.florist, color: colors.pink, size: 12.w),
        ),
        SizedBox(width: 6.w),
        Text(
          AppString.flowery,
          style: TextStyle(
            color: colors.pink,
            fontSize: 20.sp,
            fontFamily: 'serif',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onNotificationTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Badge(
          isLabelVisible: notificationCount > 0,
          backgroundColor: colors.pink,
          label: Text('$notificationCount'),
          child: Icon(AppIcons.notifications, color: colors.black, size: 24.w),
        ),
      ),
    );
  }
}
