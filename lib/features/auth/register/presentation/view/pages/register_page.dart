import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_button.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_text_feild.dart';
import 'package:flower_app/features/auth/register/domain/entity/gender.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_event.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_state.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_view_model.dart';
import 'package:flower_app/features/auth/register/presentation/widgets/register_form_footer.dart';
import 'package:flower_app/features/auth/register/presentation/widgets/register_gender_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  late final RegisterViewModel registerViewModel;
  Gender _gender = Gender.female;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _phoneController = TextEditingController();
    registerViewModel = context.read<RegisterViewModel>();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(AppIcons.chevronLeft),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
                return;
              }
              context.go(AppRoutesName.login);
            },
          ),
          title: const Text(AppString.signUp),
        ),
        body: BlocProvider(
          create: (context) => registerViewModel,
          child: BlocListener<RegisterViewModel, RegisterState>(
            listener: (context, state) {
              if (state.registerState.data != null) {
                final message = state.registerState.data!.message.isNotEmpty
                    ? state.registerState.data!.message
                    : AppString.signupSuccess;
                context.go(
                  Uri(
                    path: AppRoutesName.login,
                    queryParameters: {'success': message},
                  ).toString(),
                );
              } else if (state.registerState.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.registerState.errorMessage),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: AppString.firstName,
                              hint: AppString.enterFirstName,
                              validator: (value) => AppValidators.requiredField(
                                value,
                                field: AppString.firstName,
                              ),
                              controller: _firstNameController,
                            ),
                          ),
                          Expanded(
                            child: CustomTextField(
                              label: AppString.lastName,
                              hint: AppString.enterLastName,
                              validator: (value) => AppValidators.requiredField(
                                value,
                                field: AppString.lastName,
                              ),
                              controller: _lastNameController,
                            ),
                          ),
                        ],
                      ),
                      CustomTextField(
                        label: AppString.email,
                        hint: AppString.enterYourEmail,
                        validator: AppValidators.emailValidator,
                        controller: _emailController,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: AppString.password,
                              hint: AppString.enterPassword,
                              validator:
                                  AppValidators.registrationPasswordValidator,
                              controller: _passwordController,
                              obscureText: true,
                            ),
                          ),
                          Expanded(
                            child: CustomTextField(
                              label: AppString.confirmPassword,
                              hint: AppString.confirmPassword,
                              validator: (value) =>
                                  AppValidators.confirmPasswordValidator(
                                    value,
                                    _passwordController.text,
                                  ),
                              controller: _confirmPasswordController,
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                      CustomTextField(
                        label: AppString.phoneNumber,
                        hint: AppString.enterPhoneNumber,
                        validator: AppValidators.phoneValidator,
                        controller: _phoneController,
                      ),
                      SizedBox(height: 8.h),
                      RegisterGenderSelector(
                        value: _gender,
                        enabled: true,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),
                      const RegisterTermsText(),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<RegisterViewModel, RegisterState>(
                          builder: (context, state) {
                            return state.registerState.isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: context.colors.pink,
                                    ),
                                  )
                                : CustomButton(
                                    text: AppString.signUp,
                                    color: context.colors.white,
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        registerViewModel.doEvent(
                                          RegisterSubmitted(
                                            firstName:
                                                _firstNameController.text,
                                            lastName: _lastNameController.text,
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            confirmPassword:
                                                _confirmPasswordController.text,
                                            phoneNumber: _phoneController.text,
                                            gender: _gender.apiValue,
                                          ),
                                        );
                                      }
                                    },
                                  );
                          },
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppString.alreadyHaveAccount,
                            style: TextStyle(
                              color: context.colors.black,
                              fontSize: 16.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                                return;
                              }
                              context.go(AppRoutesName.login);
                            },
                            child: Text(
                              AppString.login,
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
