import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/payment/presentation/view_model/payment_event.dart';
import 'package:flower_app/features/payment/presentation/view_model/payment_state.dart';
import 'package:flower_app/features/payment/presentation/view_model/paymeny_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PaymentWebViewArgs {
  const PaymentWebViewArgs({
    required this.sessionUrl,
    required this.successUrl,
    required this.cancelUrl,
    this.orderId,
  });

  final String sessionUrl;
  final String successUrl;
  final String cancelUrl;
  final String? orderId;
}

class PaymentBody extends StatelessWidget {
  const PaymentBody({
    super.key,
    required this.successUrl,
    required this.cancelUrl,
  });

  final String successUrl;
  final String cancelUrl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentViewModel, PaymentState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppString.creditCard,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            AppButton(
              text: AppString.payNow,
              isLoading: state.paymentState.isLoading,
              onPressed: state.paymentState.isLoading
                  ? null
                  : () async {
                      final url = (state.sessionUrl ?? '').trim();

                      if (url.isEmpty) {
                        context.read<PaymentViewModel>().doEvent(
                          const PaymentFailed(),
                        );
                        return;
                      }

                      final result = await context.push<bool>(
                        AppRoutesName.paymentWebView,
                        extra: PaymentWebViewArgs(
                          sessionUrl: url,
                          successUrl: successUrl,
                          cancelUrl: cancelUrl,
                        ),
                      );

                      if (!context.mounted) return;

                      if (result == true) {
                        context.read<PaymentViewModel>().doEvent(
                          const PaymentSuccess(),
                        );
                      }
                    },
            ),
          ],
        );
      },
    );
  }
}

class PaymentArgs {
  const PaymentArgs({
    required this.sessionUrl,
    required this.successUrl,
    required this.cancelUrl,
    this.orderId,
  });

  final String sessionUrl;
  final String successUrl;
  final String cancelUrl;
  final String? orderId;
}
