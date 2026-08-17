import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/core/widgets/app_otp_field.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_params.dart';
import 'package:flower_app/features/forget_password/domain/entities/verify_otp_params.dart';
import 'package:flower_app/features/forget_password/presentation/pages/widgets/resend_code_button.dart';
import 'package:flower_app/features/forget_password/presentation/view_model/forget_password_cubit.dart';
import 'package:flower_app/features/forget_password/presentation/view_model/forget_password_event.dart';
import 'package:flower_app/features/forget_password/presentation/view_model/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../reset_password_page.dart';

class VerificationBody extends StatefulWidget {
  const VerificationBody({super.key});

  @override
  State<VerificationBody> createState() => _VerificationBodyState();
}

class _VerificationBodyState extends State<VerificationBody> {
  final _otpController = TextEditingController();
  String? _localOtpError;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    final localError = AppValidators.otpValidator(_otpController.text);

    setState(() => _localOtpError = localError);

    if (localError != null) {
      return;
    }

    final email = context.read<ForgetPasswordCubit>().state.email;

    final params = VerifyOtpParams(
      email: email,
      otp: _otpController.text.trim(),
    );

    context.read<ForgetPasswordCubit>().onEvent(
      ForgetPasswordEvent.verifyOtp(params: params),
    );
  }

  void _resendCode() {
    final email = context.read<ForgetPasswordCubit>().state.email;

    context.read<ForgetPasswordCubit>().onEvent(
      ForgetPasswordEvent.forgotPassword(
        params: ForgetPasswordParams(email: email),
      ),
    );
  }

  void _clearLocalErrorIfNeeded() {
    if (_localOtpError != null) {
      setState(() => _localOtpError = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listenWhen: (previous, current) =>
            previous.verifyOtpState != current.verifyOtpState,
        listener: (context, state) {
          if (state.verifyOtpState?.data != null) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),

              Text(
                AppString.verificationCode,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              SizedBox(height: 12.h),

              Text(AppString.verificationCodeDescription),

              SizedBox(height: 8.h),

              BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                buildWhen: (previous, current) =>
                    previous.email != current.email,
                builder: (context, state) {
                  return Text(
                    state.email,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  );
                },
              ),

              SizedBox(height: 40.h),

              BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                buildWhen: (previous, current) =>
                    previous.verifyOtpState != current.verifyOtpState,
                builder: (context, state) {
                  final serverHasError =
                      (state.verifyOtpState?.errorMessage ?? '').isNotEmpty;

                  final errorText =
                      _localOtpError ??
                      (serverHasError ? AppString.invalidCode : null);

                  return AppOtpField(
                    length: 6,
                    onChanged: (value) {
                      _otpController.text = value;
                      _clearLocalErrorIfNeeded();
                    },
                    onCompleted: (value) {
                      _otpController.text = value;
                    },
                    errorText: errorText,
                  );
                },
              ),

              SizedBox(height: 12.h),

              Row(
                children: [
                  Text(AppString.didntReceiveCode),
                  ResendCodeButton(onResend: _resendCode),
                ],
              ),

              SizedBox(height: 32.h),

              BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                buildWhen: (previous, current) =>
                    previous.verifyOtpState?.isLoading !=
                    current.verifyOtpState?.isLoading,
                builder: (context, state) {
                  final isLoading = state.verifyOtpState?.isLoading ?? false;

                  return AppButton(
                    text: AppString.verify,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _verifyOtp,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
