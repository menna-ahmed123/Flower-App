import 'package:flower_app/core/utils/image_path/images_path.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/app_routes.dart';
import '../../../core/animation/success_tracking_animation.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracking Order')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
        child: Column(
          children: [
            const SuccessTrackingAnimation(size: 150),
            SizedBox(height: 56.h),
            Text(
              'Your Order Placed\nSuccessfully',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            AppButton(text: 'Track Order', onPressed: () {context.push(AppRoutesName.trackOrder);}),
          ],
        ),
      ),
    );
  }
}
