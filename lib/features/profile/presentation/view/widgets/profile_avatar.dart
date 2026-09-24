import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.photoUrl,
    this.imageFile,
    this.onTap,
    this.showCamera = false,
  });

  final String? photoUrl;
  final File? imageFile;
  final VoidCallback? onTap;
  final bool showCamera;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final double avatarRadius = 40.5.r;
    final double avatarSize = avatarRadius * 2;

    return Center(
      child: SizedBox(
        width: avatarSize,
        height: avatarSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: avatarRadius,
              backgroundColor: colors.lightPink,
              child: _buildImage(colors, avatarSize),
            ),
            if (showCamera)
              Positioned(
                bottom: -2.h,
                right: -2.w,
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
                    child: Icon(
                      AppIcons.camera,
                      size: 16.w,
                      color: colors.pink,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(AppColors colors, double size) {
    if (imageFile != null) {
      return ClipOval(
        child: Image.file(
          imageFile!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    if (photoUrl == null || photoUrl!.isEmpty) {
      return Icon(AppIcons.person, size: 40.w, color: colors.pink);
    }

return ClipOval(
      child: CachedNetworkImage(
        imageUrl: ApiEndpoints.mediaUrl(photoUrl),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) =>
            Icon(AppIcons.person, size: 40.w, color: colors.pink),
      ),
    );  }
}
