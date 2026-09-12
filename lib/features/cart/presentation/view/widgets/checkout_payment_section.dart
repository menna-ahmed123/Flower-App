import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutPaymentSection extends StatelessWidget {
  const CheckoutPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutViewModel, CheckoutState>(
      buildWhen: (previous, current) =>
          previous.paymentMethod != current.paymentMethod,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppString.paymentMethod,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: context.colors.black,
              ),
            ),
            SizedBox(height: 12.h),
            for (final method in CheckoutPaymentMethods.all) ...[
              CheckoutPaymentOption(
                method: method,
                selected: state.paymentMethod == method,
              ),
              SizedBox(height: 10.h),
            ],
          ],
        );
      },
    );
  }
}

class CheckoutPaymentOption extends StatelessWidget {
  const CheckoutPaymentOption({
    super.key,
    required this.method,
    required this.selected,
  });

  final String method;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: () {
        context.read<CheckoutViewModel>().doEvent(
              SelectCheckoutPayment(method),
            );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                method,
                style: TextStyle(fontSize: 14.sp, color: colors.black),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? colors.pink : colors.grey.shade800,
            ),
          ],
        ),
      ),
    );
  }
}
