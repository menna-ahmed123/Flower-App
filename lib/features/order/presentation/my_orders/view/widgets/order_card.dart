import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/utils/image_path/images_path.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.orderImageUrl,
    required this.orderName,
    required this.orderPrice,
    required this.orderNumber,
    required this.onTrackOrder,
  });
  final String orderImageUrl;
  final String orderName;
  final String orderPrice;
  final String orderNumber;
  final VoidCallback onTrackOrder;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: context.colors.grey.shade800),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 128.w,
            height: 110.h,
            child: orderImageUrl.isEmpty
                ? SvgPicture.asset(
                    ImagesPath.orderPlaceholder,
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
              imageUrl: orderImageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  color: context.colors.pink.shade100,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  color: context.colors.pink.shade100,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.all(20.r),
                child: SvgPicture.asset(
                  ImagesPath.error,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  orderName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12.sp,
                    color: context.colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  orderPrice,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: context.colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  orderNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12.sp,
                    color: context.colors.black[50],
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(height: 36.h,child: AppButton(text: AppString.trackOrder, onPressed: onTrackOrder , isSmall: true,))
              ],
            ),
          ),
        ],
      ),
    );
  }
}