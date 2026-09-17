import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Circular avatar with a camera badge to trigger image picking.
/// Reused wherever a profile picture is editable (Edit Profile, Sign up...).
class ProfileAvatarPicker extends StatelessWidget {
  const ProfileAvatarPicker({
    super.key,
    this.imageProvider,
    this.onTap,
    this.radius,
  });

  final ImageProvider? imageProvider;
  final VoidCallback? onTap;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final avatarRadius = radius ?? 40.w;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: colors.grey.shade300,
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? Icon(
                    AppIcons.person,
                    size: avatarRadius,
                    color: colors.grey.shade700,
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.grey.shade300),
                ),
                child: Icon(AppIcons.camera, size: 16.w, color: colors.pink),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
