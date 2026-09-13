import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutSummarySection extends StatelessWidget {
  const CheckoutSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutViewModel, CheckoutState>(
      buildWhen: (previous, current) =>
          previous.previewState != current.previewState,
      builder: (context, state) {
        final preview = state.previewState;
        if (preview.isLoading && preview.data == null) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (preview.errorMessage.isNotEmpty && preview.data == null) {
          return CheckoutPreviewError(message: preview.errorMessage);
        }
        return CheckoutSummaryRows(
          cart: preview.data ?? const CartEntity.empty(),
          loading: preview.isLoading,
        );
      },
    );
  }
}

class CheckoutPreviewError extends StatelessWidget {
  const CheckoutPreviewError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: context.colors.grey.shade800,
            ),
          ),
          SizedBox(height: 16.h),
          AppButton(
            text: AppString.retry,
            onPressed: () {
              context.read<CheckoutViewModel>().doEvent(LoadCheckoutPreview());
            },
          ),
        ],
      ),
    );
  }
}

class CheckoutSummaryRows extends StatelessWidget {
  const CheckoutSummaryRows({
    super.key,
    required this.cart,
    required this.loading,
  });

  final CartEntity cart;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.grey.shade600.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: colors.black.withValues(alpha: 0.04),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          if (loading)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: const LinearProgressIndicator(),
            ),
          CheckoutAmountRow(label: AppString.subtotal, value: cart.subtotal),
          CheckoutAmountRow(
            label: AppString.deliveryFee,
            value: cart.deliveryFee,
          ),
          Divider(
            height: 16.h,
            color: colors.grey.shade600.withValues(alpha: 0.35),
          ),
          CheckoutAmountRow(
            label: AppString.total,
            value: cart.total,
            bold: true,
          ),
        ],
      ),
    );
  }
}

class CheckoutAmountRow extends StatelessWidget {
  const CheckoutAmountRow({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final double value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final valueStyle = TextStyle(
      fontSize: bold ? 16.sp : 14.sp,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      color: context.colors.black,
    );
    final labelStyle = TextStyle(
      fontSize: bold ? 16.sp : 13.sp,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      color: bold ? context.colors.black : context.colors.grey.shade800,
    );
    return Padding(
      padding: EdgeInsets.only(bottom: bold ? 4.h : 8.h),
      child: Row(
        children: [
          Text(label, style: labelStyle),
          const Spacer(),
          Text('${AppString.egp} ${value.toStringAsFixed(2)}', style: valueStyle),
        ],
      ),
    );
  }
}
