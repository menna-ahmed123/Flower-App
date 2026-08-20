import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_app_bar.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_button.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_text_feild.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_event.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_state.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  late final LoginViewModel loginViewModel;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    loginViewModel = context.read<LoginViewModel>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: AppString.login),

        body: BlocProvider(
          create: (context) => loginViewModel,
          child: BlocListener<LoginViewModel, LoginState>(
            listener: (context, state) {
              if (state.loginState.data != null) {
                context.go(AppRoutesName.home);
              } else if (state.loginState.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.loginState.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        label: AppString.email,
                        hint: AppString.enterYourEmail,
                        validator: AppValidators.emailValidator,
                        controller: _emailController,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        label: AppString.password,
                        hint: AppString.enterYourPassword,
                        validator: AppValidators.passwordValidator,
                        controller: _passwordController,
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Row(
                            children: [
                              Checkbox(
                                activeColor: context.colors.pink,
                                side: BorderSide(
                                  color: context.colors.grey[900] ?? Colors.grey,
                                  width: 1.5.w,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              Text(
                                AppString.rememberMe,
                                style: TextStyle(
                                  color: context.colors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  context.push(AppRoutesName.forgetPassword);
                                },
                                child: Text(
                                  AppString.forgetPassword,
                                  style: TextStyle(
                                    color: context.colors.pink,
                                    fontSize: 14.sp,
                                    decoration: TextDecoration.underline,
                                    decorationColor: context.colors.pink,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<LoginViewModel, LoginState>(
                          builder: (context, state) {
                            return state.loginState.isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: context.colors.pink,
                                    ),
                                  )
                                : CustomButton(
                                    text: AppString.login,
                                    color: context.colors.white,
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        loginViewModel.doEvent(
                                          LoginSubmitted(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          ),
                                        );
                                      }
                                    },
                                  );
                          },
                        ),
                      ),
              
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: "Continue as guest",
                          color: context.colors.black[50] ?? Colors.grey,
                          backgroundColor: context.colors.white,
                          borderColor: context.colors.black,
                          onTap: () {
                            context.push(AppRoutesName.home);
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppString.dontHaveAccount,
                            style: TextStyle(
                              color: context.colors.black,
                              fontSize: 16.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(AppRoutesName.register);
                            },
                            child: Text(
                              AppString.signUp,
                              style: TextStyle(
                                color: context.colors.pink,
                                fontSize: 16.sp,
                                decoration: TextDecoration.underline,
                                decorationColor: context.colors.pink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
