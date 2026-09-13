import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartFooter extends StatelessWidget {
  const CartFooter({super.key, required this.cart, this.onCheckout});

  final CartEntity cart;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final horizontal = MediaQuery.sizeOf(context).width >= 600 ? 48.w : 16.w;
    return Material(
      color: colors.white,
      elevation: 0,
      child: DecoratedBox(
        decoration: _decoration(colors),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(horizontal, 14.h, horizontal, 12.h),
            child: _summary(context),
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration(AppColors colors) {
    return BoxDecoration(
      color: colors.white,
      border: Border(
        top: BorderSide(color: colors.grey.shade600.withValues(alpha: 0.35)),
      ),
      boxShadow: [
        BoxShadow(
          color: colors.black.withValues(alpha: 0.06),
          blurRadius: 8.r,
          offset: Offset(0, -2.h),
        ),
      ],
    );
  }

  Widget _summary(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _row(context, AppString.subtotal, cart.subtotal),
        if (cart.deliveryFee > 0)
          _row(context, AppString.deliveryFee, cart.deliveryFee),
        Divider(
          height: 16.h,
          color: context.colors.grey.shade600.withValues(alpha: 0.35),
        ),
        _row(context, AppString.total, cart.total, bold: true),
        SizedBox(height: 14.h),
        AppButton(text: AppString.checkout, onPressed: onCheckout),
      ],
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    double value, {
    bool bold = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bold ? 0 : 6.h),
      child: Row(
        children: [
          Text(label, style: _labelStyle(context, bold)),
          const Spacer(),
          Text(
            '${AppString.egp} ${value.toStringAsFixed(2)}',
            style: _valueStyle(context, bold),
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle(BuildContext context, bool bold) {
    return TextStyle(
      fontSize: bold ? 16.sp : 13.sp,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      color: bold ? context.colors.black : context.colors.grey.shade800,
    );
  }

  TextStyle _valueStyle(BuildContext context, bool bold) {
    return TextStyle(
      fontSize: bold ? 16.sp : 14.sp,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      color: context.colors.black,
    );
  }
}
