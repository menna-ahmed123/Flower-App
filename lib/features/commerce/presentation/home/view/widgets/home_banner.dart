import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({
    super.key,
    required this.section,
    required this.onDeepLink,
  });

  final HomeSectionEntity section;
  final ValueChanged<String> onDeepLink;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      child: GestureDetector(
        onTap: _onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: AspectRatio(aspectRatio: 343 / 150, child: _image(context)),
        ),
      ),
    );
  }

  void _onTap() {
    if (section.deepLink.isNotEmpty) onDeepLink(section.deepLink);
  }

  Widget _image(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: section.imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, _) => ColoredBox(color: context.colors.grey.shade300),
      errorWidget: (_, _, _) {
        return ColoredBox(color: context.colors.grey.shade300);
      },
    );
  }
}
