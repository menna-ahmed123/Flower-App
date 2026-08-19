import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/widgets/app_text_field.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/reset_password_params.dart';
import 'package:flower_app/features/auth/forget_password/presentation/view_model/forget_password_cubit.dart';
import 'package:flower_app/features/auth/forget_password/presentation/view_model/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/constants/app_string.dart';
import '../../../../../../core/helpers/app_validators.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../view_model/forget_password_event.dart';

class ResetPasswordBody extends StatefulWidget {
  const ResetPasswordBody({super.key});

  @override
  State<ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<ResetPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _resetPasswordSuccess() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(AppString.resetPasswordSuccess)));
    context.go(AppRoutesName.home);
  }

  void _resetPasswordError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final resetToken = context
        .read<ForgetPasswordCubit>()
        .state
        .verifyOtpState
        ?.data
        ?.resetToken;

    final params = ResetPasswordParams(
      confirmPassword: _confirmPasswordController.text.trim(),
      newPassword: _passwordController.text.trim(),
      resetToken: resetToken,
    );

    context.read<ForgetPasswordCubit>().onEvent(
      ForgetPasswordEvent.resetPassword(params: params),
    );
  }

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listenWhen: (previous, current) =>
            previous.resetPasswordState?.data !=
                current.resetPasswordState?.data ||
            previous.resetPasswordState?.errorMessage !=
                current.resetPasswordState?.errorMessage,
        listener: (context, state) {
          final resetState = state.resetPasswordState;

          if (resetState?.data != null) {
            _resetPasswordSuccess();
          } else if (resetState?.errorMessage.isNotEmpty ?? false) {
            _resetPasswordError(resetState!.errorMessage);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    AppString.resetPassword,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      AppString.resetPasswordDescription,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  AppTextField(
                    label: AppString.newPassword,
                    hint: AppString.enterYourPassword,
                    controller: _passwordController,
                    validator: AppValidators.passwordValidator,
                    isPassword: true,
                  ),
                  SizedBox(height: 24.h),
                  AppTextField(
                    label: AppString.confirmPassword,
                    hint: AppString.confirmPassword,
                    controller: _confirmPasswordController,
                    validator: (value) {
                      return AppValidators.confirmPasswordValidator(
                        value,
                        _passwordController.text,
                      );
                    },
                    isPassword: true,
                  ),
                  SizedBox(height: 48.h),
                  BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                    buildWhen: (previous, current) =>
                        previous.resetPasswordState?.isLoading !=
                        current.resetPasswordState?.isLoading,
                    builder: (context, state) {
                      final isLoading =
                          state.resetPasswordState?.isLoading ?? false;
                      return AppButton(
                        text: AppString.confirm,
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _submit,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
