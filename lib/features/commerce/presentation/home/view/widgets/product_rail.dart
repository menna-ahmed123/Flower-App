import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/navigation/product_navigation.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flower_app/features/commerce/core/widgets/product_card.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/auth/auth_extension.dart';

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
      onAddToCart: () => _addToCart(context, item.id),
      onTap: () => navigateToProductDetails(context, item.id),
    );
  }

  Future<void> _addToCart(BuildContext context, String productId) {
    return context.requireAuth(
      action: () {
        return context.read<CartViewModel>().doEvent(
          AddCartItemEvent(productId: productId),
        );
      },
    );
  }
}
