import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OccasionRail extends StatelessWidget {
  const OccasionRail({
    super.key,
    required this.section,
    required this.onDeepLink,
  });

  final HomeSectionEntity section;
  final ValueChanged<String> onDeepLink;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: section.title,
          actionLabel: section.viewAllLabel,
          onAction: section.viewAllDeepLink.isEmpty ? null : _onViewAll,
        ),
        SizedBox(height: 196.h, child: _list()),
      ],
    );
  }

  void _onViewAll() {
    if (section.viewAllDeepLink.isNotEmpty) {
      onDeepLink(section.viewAllDeepLink);
    }
  }

  Widget _list() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: section.items.length,
      separatorBuilder: (_, _) => SizedBox(width: 12.w),
      itemBuilder: _item,
    );
  }

  Widget _item(BuildContext context, int index) {
    final item = section.items[index];
    return _OccasionCard(
      item: item,
      onTap: () => onDeepLink(item.deepLink ?? section.viewAllDeepLink),
    );
  }
}

class _OccasionCard extends StatelessWidget {
  const _OccasionCard({required this.item, required this.onTap});

  final HomeRailItemEntity item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _image(context),
            SizedBox(height: 8.h),
            _label(context),
          ],
        ),
      ),
    );
  }

  Widget _image(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: CachedNetworkImage(
        imageUrl: item.imageUrl,
        width: 140.w,
        height: 160.h,
        fit: BoxFit.cover,
        placeholder: (_, _) => ColoredBox(color: context.colors.grey.shade300),
        errorWidget: (_, _, _) {
          return ColoredBox(color: context.colors.grey.shade300);
        },
      ),
    );
  }

  Widget _label(BuildContext context) {
    return Text(
      item.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: context.colors.black, fontSize: 14.sp),
    );
  }
}
