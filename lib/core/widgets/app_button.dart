import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppButtonVariant { primary, outlined }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;

  bool get _isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: double.infinity,
      child: switch (variant) {
        AppButtonVariant.primary => _buildPrimaryButton(colors),
        AppButtonVariant.outlined => _buildOutlinedButton(colors),
      },
    );
  }

  Widget _buildPrimaryButton(AppColors colors) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        backgroundColor: colors.pink,
        foregroundColor: colors.white,
        disabledBackgroundColor: colors.disabledButton,
        disabledForegroundColor: colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
      child: _buildChild(colors),
    );
  }

  Widget _buildOutlinedButton(AppColors colors) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        backgroundColor: colors.white,
        foregroundColor: colors.grey.shade900,
        disabledBackgroundColor: colors.white,
        disabledForegroundColor: colors.grey.shade700,
        side: BorderSide(
          color: _isDisabled ? colors.grey.shade500 : colors.black,
          width: 1.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
      child: _buildChild(colors),
    );
  }

  Widget _buildChild(AppColors colors) {
    if (!isLoading) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return _buildLoadingChild(colors);
  }

  Widget _buildLoadingChild(AppColors colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 12.w),
        SizedBox(
          width: 18.w,
          height: 18.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: variant == AppButtonVariant.primary
                ? colors.white
                : colors.black,
          ),
        ),
      ],
    );
  }
}