import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/utils/commerce_widgets/product_card.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductRail extends StatelessWidget {
  const ProductRail({
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
        SizedBox(height: 280.h, child: _list()),
      ],
    );
  }

  void _onViewAll() {
    if (section.viewAllDeepLink.isNotEmpty) {
      onDeepLink(section.viewAllDeepLink);
    }
  }

  Widget _list() {
    if (section.items.isEmpty) {
      return const Center(child: Text(AppString.noResultsFound));
    }
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
    return ProductCard(
      imageUrl: item.imageUrl,
      name: item.name,
      price: item.price ?? '',
      oldPrice: item.oldPrice,
      discount: item.discount,
      onAddToCart: () {},
      onTap: () => onDeepLink(item.deepLink ?? section.viewAllDeepLink),
    );
  }
}
