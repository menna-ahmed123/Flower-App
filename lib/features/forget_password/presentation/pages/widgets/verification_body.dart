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

  void _onOtpChanged(String value) {
    _otpController.text = value;
    _clearLocalErrorIfNeeded();
  }

  void _onOtpCompleted(String value) {
    _otpController.text = value;
  }

  bool _listenWhen(ForgetPasswordState previous, ForgetPasswordState current) {
    return previous.verifyOtpState != current.verifyOtpState;
  }

  void _listener(BuildContext context, ForgetPasswordState state) {
    if (state.verifyOtpState?.data != null) {
      // Navigate to reset password page.
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listenWhen: _listenWhen,
        listener: _listener,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60.h),
          _buildTitle(context),
          SizedBox(height: 12.h),
          Text(AppString.verificationCodeDescription),
          SizedBox(height: 8.h),
          _buildEmail(),
          SizedBox(height: 40.h),
          _buildOtpField(),
          SizedBox(height: 12.h),
          _buildResendRow(),
          SizedBox(height: 32.h),
          _buildVerifyButton(),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      AppString.verificationCode,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildEmail() {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Text(
          state.email,
          style: const TextStyle(fontWeight: FontWeight.w600),
        );
      },
    );
  }

  Widget _buildOtpField() {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      buildWhen: (previous, current) =>
          previous.verifyOtpState != current.verifyOtpState,
      builder: (context, state) {
        final serverHasError =
            (state.verifyOtpState?.errorMessage ?? '').isNotEmpty;

        final errorText =
            _localOtpError ?? (serverHasError ? AppString.invalidCode : null);

        return AppOtpField(
          length: 6,
          onChanged: _onOtpChanged,
          onCompleted: _onOtpCompleted,
          errorText: errorText,
        );
      },
    );
  }

  Widget _buildResendRow() {
    return Row(
      children: [
        Text(AppString.didntReceiveCode),
        ResendCodeButton(onResend: _resendCode),
      ],
    );
  }

  Widget _buildVerifyButton() {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
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
    );
  }
}
