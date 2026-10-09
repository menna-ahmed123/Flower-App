
import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        context.go(AppRoutesName.home);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: CustomAppBar(
          title: AppString.trackOrder,
          onBack: () => context.go(AppRoutesName.home),
        ),
        body: ConfirmationBody(orderId: orderId),
      ),
    );
  }
}

class ConfirmationBody extends StatelessWidget {
  const ConfirmationBody({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            // Center the success content vertically
            const Spacer(flex: 3),

            // Large green success circles
            const SuccessIndicator(),

            SizedBox(height: 32.h),

            // Success message
            Text(
              AppString.orderPlacedSuccess,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                height: 1.3,
                fontWeight: FontWeight.w600,
                color: context.colors.black,
              ),
            ),

            SizedBox(height: 32.h),

            // Track order button - original navigation preserved
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: AppButton(
                text: AppString.trackOrder,
                onPressed: () {
                  context.go(
                    AppRoutesName.trackOrder,
                    extra: orderId,
                  );
                },
              ),
            ),

            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}

class SuccessIndicator extends StatelessWidget {
  const SuccessIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180.w,
      height: 180.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _circle(180.w, const Color(0xFFE8FBEA)),
          _circle(150.w, const Color(0xFFD5F8D9)),
          _circle(120.w, const Color(0xFFB9F2C0)),
          _circle(90.w, const Color(0xFF91E99D)),

          Icon(
            Icons.check,
            color: Colors.white,
            size: 52.w,
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppString.trackOrder,
        onBack: () => context.go(AppRoutesName.home),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Text(
          '${AppString.orderDetails}\n${orderId ?? ''}',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: context.colors.black,
          ),
        ),
      ),
    );
  }
}
