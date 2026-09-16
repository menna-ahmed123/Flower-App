import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Matches the Figma "Home & description" block: a location icon/label followed by the address line.
class OrderDeliveryInfo extends StatelessWidget {
  const OrderDeliveryInfo({
    super.key,
    required this.recipientName,
    required this.recipientPhone,
    required this.addressLine,
    required this.city,
    required this.area,
  });

  final String recipientName;
  final String recipientPhone;
  final String addressLine;
  final String city;
  final String area;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(AppIcons.location, color: colors.black, size: 24.w),
            SizedBox(width: 8.w),
            Text(
              AppString.deliveryInformation,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: colors.black),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        if (recipientName.isNotEmpty)
          Text(recipientName, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: colors.black)),
        if (recipientPhone.isNotEmpty)
          Text(recipientPhone, style: TextStyle(fontSize: 13.sp, color: colors.grey.shade700)),
        Text('$addressLine, $area, $city', style: TextStyle(fontSize: 13.sp, color: colors.grey.shade700)),
      ],
    );
  }
}
