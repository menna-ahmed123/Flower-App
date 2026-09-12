import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppString.confirmation,
        onBack: () => context.go(AppRoutesName.home),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AppIcons.checkCircle, color: context.colors.green, size: 72.w),
            SizedBox(height: 16.h),
            Text(
              AppString.orderPlacedSuccess,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: context.colors.black,
              ),
            ),
            SizedBox(height: 32.h),
            AppButton(
              text: AppString.home,
              onPressed: () => context.go(AppRoutesName.home),
            ),
          ],
        ),
      ),
    );
  }
}
