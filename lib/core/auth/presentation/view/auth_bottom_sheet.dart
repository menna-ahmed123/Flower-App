import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

Future<void> showLoginBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppString.login,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8.h),
            const Text(AppString.loginToContinue),
            SizedBox(height: 24.h),
            AppButton(
              text: AppString.login,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(AppRoutesName.login);
              },
            ),
            SizedBox(height: 12.h),
            AppButton(
              variant: AppButtonVariant.outlined,
              text: AppString.signUp,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(AppRoutesName.register);
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      );
    },
  );
}
