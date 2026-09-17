import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/profile/presentation/models/profile_display_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Avatar, name, email and edit-profile entry point of the signed-in user.
class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({super.key, required this.data, this.onEditTap});

  final ProfileDisplayData data;

  /// Called when the pen icon next to the user's name is tapped.
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
            SizedBox(width: 8.w),
            _buildEditButton(),
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

  Widget _buildEditButton() {
    return InkWell(
      key: const Key('profileEditButton'),
      onTap: onEditTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: SvgPicture.asset(
          AppIcons.editProfilePen,
          width: 16.w,
          height: 16.w,
        ),
      ),
    );
  }

  Widget _buildAvatar(AppColors colors) {
    final photoUrl = data.photoUrl;

    return CircleAvatar(
      radius: 40.5.r,
      backgroundColor: colors.lightPink,
      // CircleAvatar already clips its child to a circle; no extra ClipOval
      // needed here.
      child: photoUrl == null || photoUrl.isEmpty
          ? Icon(AppIcons.person, size: 40.w, color: colors.pink)
          : CachedNetworkImage(
              imageUrl: photoUrl,
              width: 81.w,
              height: 81.w,
              fit: BoxFit.cover,
              // A non-empty but broken/relative URL (e.g. unconfigured
              // base URL) should still fall back to the placeholder icon
              // instead of a blank circle.
              errorWidget: (context, url, error) =>
                  Icon(AppIcons.person, size: 40.w, color: colors.pink),
            ),
    );
  }
}
