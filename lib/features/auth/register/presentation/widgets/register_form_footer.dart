import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/auth/register/presentation/intent/register_intent.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class RegisterSubmitButton extends StatelessWidget {
  const RegisterSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.white;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading ? loadingChild(color) : submitLabel(color),
      ),
    );
  }

  Widget loadingChild(Color color) {
    return SizedBox(
      height: 22.h,
      width: 22.h,
      child: CircularProgressIndicator(strokeWidth: 2.5, color: color),
    );
  }

  Widget submitLabel(Color color) {
    return Text(
      AppString.signUp,
      style: TextStyle(
        color: color,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class RegisterLoginLink extends StatelessWidget {
  const RegisterLoginLink({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(AppString.alreadyHaveAccount, style: TextStyle(fontSize: 14.sp)),
        loginButton(context),
      ],
    );
  }

  Widget loginButton(BuildContext context) {
    final colors = context.colors;
    return TextButton(
      onPressed: enabled ? () => navigateToLogin(context) : null,
      style: loginButtonStyle(colors),
      child: loginLabel(colors),
    );
  }

  void navigateToLogin(BuildContext context) {
    context.read<RegisterBloc>().add(const NavigateToLoginIntent());
  }

  ButtonStyle loginButtonStyle(AppColors colors) {
    return TextButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      foregroundColor: colors.pink,
    );
  }

  Widget loginLabel(AppColors colors) {
    return Text(
      AppString.login,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
        decorationColor: colors.pink,
      ),
    );
  }
}
