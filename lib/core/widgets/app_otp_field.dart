import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class AppOtpField extends StatefulWidget {
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
  State<AppOtpField> createState() => AppOtpFieldState();
}

class AppOtpFieldState extends State<AppOtpField> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasError = widget.errorText != null;
    final themes = _buildPinThemes(colors);

    return Pinput(
      length: widget.length,
      enabled: widget.enabled,
      autofocus: widget.autoFocus,
      keyboardType: TextInputType.number,
      onChanged: widget.onChanged,
      onCompleted: widget.onCompleted,
      validator: widget.validator,
      defaultPinTheme: themes.defaultTheme,
      focusedPinTheme: themes.focusedTheme,
      submittedPinTheme: themes.submittedTheme,
      errorPinTheme: themes.errorTheme,
      disabledPinTheme: themes.disabledTheme,
      forceErrorState: hasError,
      errorText: widget.errorText,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      separatorBuilder: (index) => SizedBox(width: 12.w),
      cursor: Container(width: 1.5.w, height: 24.h, color: colors.pink),
      errorTextStyle: TextStyle(color: colors.error, fontSize: 11.sp),
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
    final defaultPinTheme = PinTheme(
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

    return (
      defaultTheme: defaultPinTheme,
      focusedTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: colors.pink, width: 1.w),
        ),
      ),
      submittedTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: colors.pink, width: 1.w),
        ),
      ),
      errorTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: colors.error, width: 1.w),
        ),
      ),
      disabledTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: colors.grey.shade300,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
