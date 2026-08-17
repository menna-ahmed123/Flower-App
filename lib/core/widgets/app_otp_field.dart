import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class AppOtpField extends StatelessWidget {
  const AppOtpField({
    super.key,
    this.length = 4,
    this.onChanged,
    this.onCompleted,
    this.errorText,
    this.validator,
    this.enabled = true,
    this.autoFocus = false,
  });

  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final themes = _buildPinThemes(colors);

    return Pinput(
      length: length,
      enabled: enabled,
      autofocus: autoFocus,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      onCompleted: onCompleted,
      validator: validator,
      defaultPinTheme: themes.defaultTheme,
      focusedPinTheme: themes.focusedTheme,
      submittedPinTheme: themes.submittedTheme,
      errorPinTheme: themes.errorTheme,
      disabledPinTheme: themes.disabledTheme,
      forceErrorState: errorText != null,
      errorText: errorText,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      separatorBuilder: _separatorBuilder,
      cursor: _buildCursor(colors),
      errorTextStyle: _buildErrorTextStyle(colors),
    );
  }

  ({
    PinTheme defaultTheme,
    PinTheme focusedTheme,
    PinTheme submittedTheme,
    PinTheme errorTheme,
    PinTheme disabledTheme,
  })
  _buildPinThemes(AppColors colors) {
    final defaultPinTheme = _buildDefaultPinTheme(colors);

    return (
      defaultTheme: defaultPinTheme,
      focusedTheme: _buildFocusedPinTheme(defaultPinTheme, colors),
      submittedTheme: _buildFocusedPinTheme(defaultPinTheme, colors),
      errorTheme: _buildErrorPinTheme(defaultPinTheme, colors),
      disabledTheme: _buildDisabledPinTheme(defaultPinTheme, colors),
    );
  }

  PinTheme _buildDefaultPinTheme(AppColors colors) {
    return PinTheme(
      width: 74.w,
      height: 68.w,
      textStyle: TextStyle(
        color: colors.black,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: colors.otpColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  PinTheme _buildFocusedPinTheme(PinTheme defaultPinTheme, AppColors colors) {
    return defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: colors.pink, width: 1.w),
      ),
    );
  }

  PinTheme _buildErrorPinTheme(PinTheme defaultPinTheme, AppColors colors) {
    return defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: colors.error, width: 1.w),
      ),
    );
  }

  PinTheme _buildDisabledPinTheme(PinTheme defaultPinTheme, AppColors colors) {
    return defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: colors.grey.shade300,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  Widget _buildCursor(AppColors colors) {
    return Container(width: 1.5.w, height: 24.h, color: colors.pink);
  }

  TextStyle _buildErrorTextStyle(AppColors colors) {
    return TextStyle(color: colors.error, fontSize: 11.sp);
  }

  Widget _separatorBuilder(int index) {
    return SizedBox(width: 12.w);
  }
}
