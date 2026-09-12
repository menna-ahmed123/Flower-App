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
          return const Center(child: CircularProgressIndicator());
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
    return Column(
      children: [
        Text(message, textAlign: TextAlign.center),
        SizedBox(height: 12.h),
        AppButton(
          text: AppString.retry,
          onPressed: () {
            context.read<CheckoutViewModel>().doEvent(LoadCheckoutPreview());
          },
        ),
      ],
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
    return Column(
      children: [
        if (loading) const LinearProgressIndicator(),
        CheckoutAmountRow(label: AppString.subtotal, value: cart.subtotal),
        CheckoutAmountRow(label: AppString.deliveryFee, value: cart.deliveryFee),
        CheckoutAmountRow(label: AppString.total, value: cart.total, bold: true),
      ],
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
