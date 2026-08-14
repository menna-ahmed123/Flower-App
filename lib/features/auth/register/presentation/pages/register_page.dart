import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/auth/register/presentation/effect/register_effect.dart';
import 'package:flower_app/features/auth/register/presentation/intent/register_intent.dart';
import 'package:flower_app/features/auth/register/presentation/pages/register_page_sections.dart';
import 'package:flower_app/features/auth/register/presentation/state/register_state.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_bloc.dart';
import 'package:flower_app/features/auth/register/presentation/widgets/register_form_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key, this.createBloc});

  final RegisterBloc Function()? createBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => (createBloc ?? () => getIt<RegisterBloc>())(),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  void onRegisterState(BuildContext context, RegisterState state) {
    final effect = state.effect;
    if (effect == null) return;
    RegisterEffectHandler.handle(context, effect);
    context.read<RegisterBloc>().add(const ClearRegisterEffectIntent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listenWhen: registerEffectChanged,
      listener: onRegisterState,
      child: Scaffold(
        backgroundColor: context.colors.white,
        appBar: const RegisterAppBar(),
        body: SafeArea(child: RegisterFormList()),
      ),
    );
  }
}

class RegisterFormList extends StatelessWidget {
  const RegisterFormList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: formSections(),
    );
  }

  List<Widget> formSections() {
    return [
      const RegisterIdentityFieldsSection(),
      SizedBox(height: 18.h),
      const RegisterSecurityFieldsSection(),
      SizedBox(height: 20.h),
      const RegisterGenderSection(),
      SizedBox(height: 16.h),
      const RegisterTermsText(),
      SizedBox(height: 24.h),
      const RegisterSubmitSection(),
      SizedBox(height: 18.h),
      const RegisterLoginLinkSection(),
    ];
  }
}

class RegisterEffectHandler {
  const RegisterEffectHandler._();

  static void handle(BuildContext context, RegisterEffect effect) {
    switch (effect) {
      case NavigateToLoginEffect(:final successMessage):
        navigateToLoginWithOptionalSuccess(context, successMessage);
      case NavigateBackEffect():
        navigateBack(context);
      case ShowErrorMessageEffect(:final message):
        showFailureSnackBar(context, message);
    }
  }

  static void navigateToLoginWithOptionalSuccess(
    BuildContext context,
    String? successMessage,
  ) {
    final location = successMessage == null
        ? AppRoutesName.login
        : Uri(
            path: AppRoutesName.login,
            queryParameters: {'success': successMessage},
          ).toString();
    context.go(location);
  }

  static void navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutesName.login);
  }

  static void showFailureSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class RegisterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RegisterAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(AppIcons.chevronLeft),
        onPressed: () => context.read<RegisterBloc>().add(const NavigateBackIntent()),
      ),
      title: const Text(AppString.signUp),
    );
  }
}

bool registerEffectChanged(RegisterState previous, RegisterState current) {
  return previous.effect != current.effect;
}
