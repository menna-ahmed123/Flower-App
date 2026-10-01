import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    this.canIncrement = true,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final bool canIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _button(context, const Icon(AppIcons.minus), onDecrement),
        _quantityLabel(context),
        _button(
          context,
          const Icon(AppIcons.plus),
          canIncrement ? onIncrement : null,
        ),
      ],
    );
  }

  Widget _quantityLabel(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(
        '$quantity',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: context.colors.black,
        ),
      ),
    );
  }

  Widget _button(BuildContext context, Widget icon, VoidCallback? onPressed) {
    final colors = context.colors;
    return SizedBox(
      width: 32.w,
      height: 32.w,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        iconSize: 16.w,
        color: colors.pink,
        style: _buttonStyle(colors),
        icon: icon,
      ),
    );
  }

  ButtonStyle _buttonStyle(AppColors colors) {
    return IconButton.styleFrom(
      backgroundColor: colors.pink.shade50,
      disabledBackgroundColor: colors.grey.shade300,
      shape: CircleBorder(side: BorderSide(color: colors.pink.shade100)),
    );
  }
}
