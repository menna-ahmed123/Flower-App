import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Confirmation dialog shown before logging the user out.
///
/// Returns `true` when the user confirmed the logout, `false`/`null`
/// otherwise (Cancel or dismissed).
class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const LogoutConfirmationDialog(),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Dialog(
      backgroundColor: colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppString.logoutDialogTitle,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppString.confirmLogoutMessage,
              style: TextStyle(fontSize: 16.sp, color: colors.black),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100.w,
                  child: AppButton(
                    text: AppString.cancel,
                    variant: AppButtonVariant.outlined,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ),
                SizedBox(width: 16.w),
                SizedBox(
                  width: 100.w,
                  child: AppButton(
                    text: AppString.logout,
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
