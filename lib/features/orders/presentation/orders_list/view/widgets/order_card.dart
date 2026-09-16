import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/utils/date_formatter.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/orders/domain/entities/order_status.dart';
import 'package:flower_app/features/orders/domain/entities/order_summary_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.onTrackOrder});

  final OrderSummaryEntity order;
  final VoidCallback onTrackOrder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.grey.shade600, width: 1.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: ApiEndpoints.mediaUrl(order.previewImageUrl),
              width: 109.w,
              height: 109.h,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                width: 109.w,
                height: 109.h,
                color: colors.grey.shade300,
                child: Icon(Icons.image_not_supported_outlined, color: colors.grey.shade700),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.previewProductName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: colors.black),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${AppString.egp} ${order.totalPrice.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: colors.black),
                ),
                SizedBox(height: 4.h),
                Text(
                  _subtitle(),
                  style: TextStyle(fontSize: 12.sp, color: colors.grey.shade700),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 30.h,
                  child: AppButton(text: AppString.trackOrder, onPressed: onTrackOrder),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _subtitle() {
    if (order.status.isCompleted && order.deliveredAt != null) {
      return '${AppString.deliveredOnPrefix} ${order.deliveredAt!.toShortDate()}';
    }
    return '${AppString.orderNumberPrefix} ${order.orderNumber}';
  }
}
