import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/core/widgets/app_web_view_screen.dart';
import 'package:flower_app/core/widgets/custom_app_bar.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppString.payment,
        onBack: () {
          if (context.canPop()) context.pop();
        },
      ),
      body: BlocListener<CheckoutViewModel, CheckoutState>(
        listenWhen: (previous, current) =>
            previous.destination != current.destination ||
            previous.sessionUrl != current.sessionUrl ||
            previous.paymentState.errorMessage !=
                current.paymentState.errorMessage,
        listener: _onPayment,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: const PaymentBody(),
        ),
      ),
    );
  }
}

Future<void> _onPayment(BuildContext context, CheckoutState state) async {
  final error = state.paymentState.errorMessage;
  if (error.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    return;
  }
  if (state.destination != CheckoutDestination.confirmation) return;
  final orderId = state.orderId;
  context.read<CheckoutViewModel>().doEvent(const ClearCheckoutNavigation());
  await context.read<CartViewModel>().doEvent(const ClearCart());
  if (!context.mounted) return;
  context.push(AppRoutesName.confirmation, extra: orderId);
}

class PaymentBody extends StatelessWidget {
  const PaymentBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutViewModel, CheckoutState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppString.creditCard,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            if ((state.sessionUrl ?? '').isNotEmpty) ...[
              SizedBox(height: 16.h),
              SelectableText(state.sessionUrl!),
            ],
            const Spacer(),
            _payButton(context, state),
          ],
        );
      },
    );
  }

  void _pay(BuildContext context, CheckoutState state) {
    final url = state.sessionUrl ?? '';
    if (url.isNotEmpty) {
      context.push(
        AppRoutesName.webView,
        extra: WebViewArgs(url: url, title: AppString.payment),
      );
      return;
    }
    context.read<CheckoutViewModel>().doEvent(const ProcessCheckoutPayment());
  }

  Widget _payButton(BuildContext context, CheckoutState state) {
    return AppButton(
      text: AppString.payNow,
      isLoading: state.paymentState.isLoading,
      onPressed: state.paymentState.isLoading
          ? null
          : () => _pay(context, state),
    );
  }
}
