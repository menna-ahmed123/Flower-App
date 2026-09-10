import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/profile/presentation/models/profile_display_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Avatar, name (with an edit entry point) and email of the signed-in user.
class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({
    super.key,
    required this.data,
    this.onEditTap,
  });

  final ProfileDisplayData data;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        _buildAvatar(colors),
        SizedBox(height: 8.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data.name,
              style: TextStyle(
                color: colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              onPressed: onEditTap,
              icon: Icon(AppIcons.edit, size: 18.w, color: colors.grey.shade900),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.only(left: 4.w),
              splashRadius: 18.r,
            ),
          ],
        ),
        Text(
          data.email,
          style: TextStyle(
            color: colors.grey.shade900,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(AppColors colors) {
    final photoUrl = data.photoUrl;

    return CircleAvatar(
      radius: 40.5.r,
      backgroundColor: colors.lightPink,
      child: photoUrl == null || photoUrl.isEmpty
          ? Icon(AppIcons.person, size: 40.w, color: colors.pink)
          : ClipOval(
              child: CachedNetworkImage(
                imageUrl: photoUrl,
                width: 81.w,
                height: 81.w,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
