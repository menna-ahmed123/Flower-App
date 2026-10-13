import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/order/core/animation/success_tracking_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Your order placed successfully" screen. Navigation is the caller's job.
class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key, required this.onTrackOrder});

  final VoidCallback onTrackOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracking Order')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            const SuccessTrackingAnimation(size: 150),
            SizedBox(height: 56.h),
            Text(
              'Your Order Placed\nSuccessfully',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            AppButton(text: 'Track Order', onPressed: onTrackOrder),
          ],
        ),
      ),
    );
  }
}
