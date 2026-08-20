import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterTermsText extends StatelessWidget {
  const RegisterTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(color: context.colors.black, fontSize: 13.sp),
        children: const [
          TextSpan(text: AppString.creatingAccountAgreePrefix),
          TextSpan(
            text: AppString.termsAndConditions,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
