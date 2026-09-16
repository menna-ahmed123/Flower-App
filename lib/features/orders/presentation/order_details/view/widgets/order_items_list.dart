import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/orders/domain/entities/order_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderItemsList extends StatelessWidget {
  const OrderItemsList({super.key, required this.items});

  final List<OrderItemEntity> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(AppIcons.shoppingCart, color: colors.black, size: 24.w),
            SizedBox(width: 8.w),
            Text(
              '${items.length} ${AppString.orderItems}',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: colors.black),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        for (final item in items) _OrderItemTile(item: item),
      ],
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({required this.item});

  final OrderItemEntity item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedNetworkImage(
              imageUrl: ApiEndpoints.mediaUrl(item.imageUrl),
              width: 48.w,
              height: 48.w,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                width: 48.w,
                height: 48.w,
                color: colors.grey.shade300,
                child: Icon(Icons.image_not_supported_outlined, color: colors.grey.shade700, size: 20.w),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              '${item.productName} x${item.quantity}',
              style: TextStyle(fontSize: 14.sp, color: colors.black),
            ),
          ),
          Text(
            '${AppString.egp} ${(item.unitPrice * item.quantity).toStringAsFixed(0)}',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: colors.black),
          ),
        ],
      ),
    );
  }
}
