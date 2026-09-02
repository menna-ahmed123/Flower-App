import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartFooter extends StatelessWidget {
  const CartFooter({super.key, required this.cart});

  final CartEntity cart;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.white,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
          child: _summary(context),
        ),
      ),
    );
  }

  Widget _summary(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _row(context, AppString.subtotal, cart.subtotal),
        if (cart.deliveryFee > 0)
          _row(context, AppString.deliveryFee, cart.deliveryFee),
        _row(context, AppString.total, cart.total, bold: true),
        SizedBox(height: 16.h),
        AppButton(text: AppString.checkout, onPressed: () {}),
      ],
    );
  }

  Widget _row(BuildContext context, String label, double value, {bool bold = false}) {
    final style = TextStyle(
      fontSize: bold ? 16.sp : 14.sp,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      color: context.colors.black,
    );
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text('${AppString.egp} ${value.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }
}
