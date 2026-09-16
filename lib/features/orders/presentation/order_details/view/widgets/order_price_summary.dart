import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderPriceSummary extends StatelessWidget {
  const OrderPriceSummary({super.key, required this.subtotal, required this.deliveryFee, required this.total});

  final double subtotal;
  final double deliveryFee;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PriceRow(label: AppString.subtotal, value: subtotal),
        SizedBox(height: 8.h),
        _PriceRow(label: AppString.deliveryFee, value: deliveryFee),
        SizedBox(height: 8.h),
        _PriceRow(label: AppString.total, value: total, isEmphasized: true),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value, this.isEmphasized = false});

  final String label;
  final double value;
  final bool isEmphasized;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = TextStyle(
      fontSize: isEmphasized ? 16.sp : 14.sp,
      fontWeight: isEmphasized ? FontWeight.w700 : FontWeight.w400,
      color: colors.black,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('${AppString.egp} ${value.toStringAsFixed(0)}', style: style),
      ],
    );
  }
}
