import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/core/widgets/app_otp_field.dart';
import 'package:flower_app/features/forget_password/domain/entities/verify_otp_params.dart';
import 'package:flower_app/features/forget_password/presentation/view_model/forget_password_cubit.dart';
import 'package:flower_app/features/forget_password/presentation/view_model/forget_password_event.dart';
import 'package:flower_app/features/forget_password/presentation/view_model/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerificationBody extends StatefulWidget {
  const VerificationBody({super.key});

  @override
  State<VerificationBody> createState() => _VerificationBodyState();
}

class _VerificationBodyState extends State<VerificationBody> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    if (!_formKey.currentState!.validate()) {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listenWhen: (previous, current) =>
            previous.verifyOtpState != current.verifyOtpState,
        listener: (context, state) {
          if (state.verifyOtpState?.data != null) {
            // Navigate to reset password page.
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
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

                AppOtpField(
                  length: 6,
                  onChanged: (value) {
                    _otpController.text = value;
                  },
                  onCompleted: (value) {
                    _otpController.text = value;
                  },
                  errorText: null,
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
      ),
    );
  }
}
