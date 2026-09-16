import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Matches the Figma "Home & description" block: a payment icon/amount followed by the payment method caption.
class OrderPaymentInfo extends StatelessWidget {
  const OrderPaymentInfo({super.key, required this.total, required this.paymentMethod});

  final double total;
  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(AppIcons.payments, color: colors.black, size: 24.w),
            SizedBox(width: 8.w),
            Text(
              '${AppString.egp} ${total.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: colors.black),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(paymentMethod, style: TextStyle(fontSize: 13.sp, color: colors.grey.shade700)),
      ],
    );
  }
}
