import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCateg extends StatelessWidget {
  const CustomCateg({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72.w,
        child: Column(
          children: [
            _iconBox(context),
            SizedBox(height: 6.h),
            _label(context),
          ],
        ),
      ),
    );
  }

  Widget _iconBox(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 68.w,
      height: 68.w,
      decoration: BoxDecoration(
        color: colors.pink.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: Alignment.center,
      child: _image(colors),
    );
  }

  Widget _image(AppColors colors) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 36.w,
        height: 36.w,
        fit: BoxFit.contain,
        errorWidget: (_, _, _) {
          return Icon(AppIcons.florist, color: colors.pink, size: 28.w);
        },
      ),
    );
  }

  Widget _label(BuildContext context) {
    return Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(color: context.colors.black, fontSize: 13.sp),
    );
  }
}
