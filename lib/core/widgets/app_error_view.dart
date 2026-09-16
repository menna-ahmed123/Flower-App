import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable centered error state with a retry action, shared across feature screens.
class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: colors.error, size: 60),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyle(fontSize: 16.sp, color: colors.black, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.pink,
                foregroundColor: colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: onRetry,
              child: Text(AppString.retry),
            ),
          ],
        ),
      ),
    );
  }
}
