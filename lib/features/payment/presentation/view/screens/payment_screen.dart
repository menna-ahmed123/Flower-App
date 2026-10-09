import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/custom_app_bar.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flower_app/features/payment/presentation/view/widgets/payment_body.dart';
import 'package:flower_app/features/payment/presentation/view_model/payment_state.dart';
import 'package:flower_app/features/payment/presentation/view_model/paymeny_view_model.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({
    super.key,
    this.orderId,
    required this.successUrl,
    required this.cancelUrl,
  });

  final String? orderId;
  final String successUrl;
  final String cancelUrl;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (context.canPop()) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppString.payment,
          onBack: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        body: BlocListener<PaymentViewModel, PaymentState>(
          listenWhen: (previous, current) =>
              previous.paymentState != current.paymentState ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) async {
            if (state.paymentState.data == state.paymentState.data){
              await context.read<CartViewModel>().doEvent(
                    const ClearCart(),
                  );

              if (!context.mounted) return;

              context.go(
                AppRoutesName.confirmation,
                extra: orderId,
              );
            } else if (
                state.paymentState.errorMessage == state.paymentState.errorMessage) {
              final error = state.errorMessage?.trim();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    error == null || error.isEmpty
                        ? AppString.paymentFailed
                        : error,
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: PaymentBody(
              successUrl: successUrl,
              cancelUrl: cancelUrl,
            ),
          ),
        ),
      ),
    );
  }
}
