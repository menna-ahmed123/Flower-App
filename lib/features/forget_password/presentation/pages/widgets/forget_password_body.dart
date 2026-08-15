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
  State<ForgetPasswordBody> createState() => _ForgetPasswordBodyState();
}

class _ForgetPasswordBodyState extends State<ForgetPasswordBody> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listenWhen: (previous, current) =>
            previous.forgotPasswordState != current.forgotPasswordState,
        listener: (context, state) {
          if (state.forgotPasswordState?.data != null) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const VerificationPage()));
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
                  AppString.forgotPassword,
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                SizedBox(height: 12.h),

                Text(AppString.forgotPasswordDescription),

                SizedBox(height: 40.h),

                Text(AppString.email),

                SizedBox(height: 8.h),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: AppString.enterYourEmail,
                  ),
                  validator: AppValidators.emailValidator,
                ),

                SizedBox(height: 32.h),

                BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                  buildWhen: (previous, current) =>
                      previous.forgotPasswordState?.isLoading !=
                      current.forgotPasswordState?.isLoading,
                  builder: (context, state) {
                    final isLoading =
                        state.forgotPasswordState?.isLoading ?? false;

                    return AppButton(
                      text: AppString.sendCode,
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
    );
  }
}
