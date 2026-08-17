import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_params.dart';
import 'package:flower_app/features/forget_password/presentation/pages/verification_page.dart';
import 'package:flower_app/features/forget_password/presentation/view_model/forget_password_cubit.dart';
import 'package:flower_app/features/forget_password/presentation/view_model/forget_password_event.dart';
import 'package:flower_app/features/forget_password/presentation/view_model/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordBody extends StatefulWidget {
  const ForgetPasswordBody({super.key});

  @override
  State<ForgetPasswordBody> createState() => ForgetPasswordBodyState();
}

class ForgetPasswordBodyState extends State<ForgetPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final params = ForgetPasswordParams(email: _emailController.text.trim());

    context.read<ForgetPasswordCubit>().onEvent(
      ForgetPasswordEvent.forgotPassword(params: params),
    );
  }

  bool _listenWhen(ForgetPasswordState previous, ForgetPasswordState current) {
    return previous.forgotPasswordState != current.forgotPasswordState;
  }

  void _listener(BuildContext context, ForgetPasswordState state) {
    if (state.forgotPasswordState?.data != null) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const VerificationPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listenWhen: _listenWhen,
        listener: _listener,
        child: _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            _buildTitle(context),
            SizedBox(height: 12.h),
            Text(AppString.forgotPasswordDescription),
            SizedBox(height: 40.h),
            Text(AppString.email),
            SizedBox(height: 8.h),
            _buildEmailField(),
            SizedBox(height: 32.h),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      AppString.forgotPassword,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(hintText: AppString.enterYourEmail),
      validator: AppValidators.emailValidator,
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      buildWhen: (previous, current) =>
          previous.forgotPasswordState?.isLoading !=
          current.forgotPasswordState?.isLoading,
      builder: (context, state) {
        final isLoading = state.forgotPasswordState?.isLoading ?? false;

        return AppButton(
          text: AppString.sendCode,
          isLoading: isLoading,
          onPressed: isLoading ? null : _submit,
        );
      },
    );
  }
}
