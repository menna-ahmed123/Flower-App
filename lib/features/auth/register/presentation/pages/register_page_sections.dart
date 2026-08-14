import 'package:flower_app/features/auth/register/presentation/intent/register_intent.dart';
import 'package:flower_app/features/auth/register/presentation/state/register_state.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_bloc.dart';
import 'package:flower_app/features/auth/register/presentation/widgets/register_field_widgets.dart';
import 'package:flower_app/features/auth/register/presentation/widgets/register_form_footer.dart';
import 'package:flower_app/features/auth/register/presentation/widgets/register_gender_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

bool registerLoadingChanged(RegisterState previous, RegisterState current) {
  return previous.isLoading != current.isLoading;
}

bool registerIdentityChanged(RegisterState previous, RegisterState current) {
  return previous.firstName != current.firstName ||
      previous.lastName != current.lastName ||
      previous.email != current.email ||
      previous.fieldErrors.firstName != current.fieldErrors.firstName ||
      previous.fieldErrors.lastName != current.fieldErrors.lastName ||
      previous.fieldErrors.email != current.fieldErrors.email;
}

bool registerSecurityChanged(RegisterState previous, RegisterState current) {
  return previous.password != current.password ||
      previous.confirmPassword != current.confirmPassword ||
      previous.phoneNumber != current.phoneNumber ||
      previous.obscurePassword != current.obscurePassword ||
      previous.obscureConfirmPassword != current.obscureConfirmPassword ||
      previous.fieldErrors.password != current.fieldErrors.password ||
      previous.fieldErrors.confirmPassword != current.fieldErrors.confirmPassword ||
      previous.fieldErrors.phoneNumber != current.fieldErrors.phoneNumber;
}

bool registerGenderChanged(RegisterState previous, RegisterState current) {
  return previous.gender != current.gender;
}

class RegisterLoadingGuard extends StatelessWidget {
  const RegisterLoadingGuard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: registerLoadingChanged,
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.isLoading,
          child: child,
        );
      },
    );
  }
}

class RegisterIdentityFieldsSection extends StatelessWidget {
  const RegisterIdentityFieldsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterLoadingGuard(
      child: BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: registerIdentityChanged,
        builder: (context, state) => RegisterIdentityFieldsContent(state: state),
      ),
    );
  }
}

class RegisterIdentityFieldsContent extends StatelessWidget {
  const RegisterIdentityFieldsContent({super.key, required this.state});

  final RegisterState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterBloc>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RegisterIdentityNameFields(state: state, bloc: bloc),
        SizedBox(height: 18.h),
        RegisterIdentityEmailField(state: state, bloc: bloc),
      ],
    );
  }
}

class RegisterIdentityNameFields extends StatelessWidget {
  const RegisterIdentityNameFields({
    super.key,
    required this.state,
    required this.bloc,
  });

  final RegisterState state;
  final RegisterBloc bloc;

  @override
  Widget build(BuildContext context) {
    final errors = state.fieldErrors;
    return RegisterNameFields(
      firstName: state.firstName,
      lastName: state.lastName,
      firstNameError: errors.firstName,
      lastNameError: errors.lastName,
      enabled: true,
      onFirstNameChanged: (value) => bloc.add(
        RegisterFieldChangedIntent(RegisterField.firstName, value),
      ),
      onLastNameChanged: (value) => bloc.add(
        RegisterFieldChangedIntent(RegisterField.lastName, value),
      ),
    );
  }
}

class RegisterIdentityEmailField extends StatelessWidget {
  const RegisterIdentityEmailField({
    super.key,
    required this.state,
    required this.bloc,
  });

  final RegisterState state;
  final RegisterBloc bloc;

  @override
  Widget build(BuildContext context) {
    return RegisterEmailField(
      value: state.email,
      errorText: state.fieldErrors.email,
      enabled: true,
      onChanged: (value) => bloc.add(
        RegisterFieldChangedIntent(RegisterField.email, value),
      ),
    );
  }
}

class RegisterSecurityFieldsSection extends StatelessWidget {
  const RegisterSecurityFieldsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterLoadingGuard(
      child: BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: registerSecurityChanged,
        builder: (context, state) => RegisterSecurityFieldsContent(state: state),
      ),
    );
  }
}

class RegisterSecurityFieldsContent extends StatelessWidget {
  const RegisterSecurityFieldsContent({super.key, required this.state});

  final RegisterState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterBloc>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        passwordFields(bloc),
        SizedBox(height: 18.h),
        phoneField(bloc),
      ],
    );
  }

  Widget passwordFields(RegisterBloc bloc) {
    final errors = state.fieldErrors;
    return RegisterPasswordFields(
      password: state.password,
      confirmPassword: state.confirmPassword,
      obscurePassword: state.obscurePassword,
      obscureConfirmPassword: state.obscureConfirmPassword,
      errors: errors,
      onPasswordChanged: (value) => bloc.add(
        RegisterFieldChangedIntent(RegisterField.password, value),
      ),
      onConfirmPasswordChanged: (value) => bloc.add(
        RegisterFieldChangedIntent(RegisterField.confirmPassword, value),
      ),
      onTogglePassword: () => bloc.add(const TogglePasswordVisibilityIntent()),
      onToggleConfirmPassword: () => bloc.add(
        const TogglePasswordVisibilityIntent(confirm: true),
      ),
    );
  }

  Widget phoneField(RegisterBloc bloc) {
    return RegisterPhoneField(
      value: state.phoneNumber,
      errorText: state.fieldErrors.phoneNumber,
      enabled: true,
      onChanged: (value) => bloc.add(
        RegisterFieldChangedIntent(RegisterField.phoneNumber, value),
      ),
    );
  }
}

class RegisterGenderSection extends StatelessWidget {
  const RegisterGenderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterLoadingGuard(
      child: BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: registerGenderChanged,
        builder: (context, state) {
          final bloc = context.read<RegisterBloc>();
          return RegisterGenderSelector(
            value: state.gender,
            enabled: true,
            onChanged: (value) => bloc.add(RegisterGenderChangedIntent(value)),
          );
        },
      ),
    );
  }
}

class RegisterSubmitSection extends StatelessWidget {
  const RegisterSubmitSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: registerLoadingChanged,
      builder: (context, state) {
        return RegisterSubmitButton(
          isLoading: state.isLoading,
          onPressed: () {
            FocusScope.of(context).unfocus();
            context.read<RegisterBloc>().add(const SubmitRegisterIntent());
          },
        );
      },
    );
  }
}

class RegisterLoginLinkSection extends StatelessWidget {
  const RegisterLoginLinkSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: registerLoadingChanged,
      builder: (context, state) {
        return RegisterLoginLink(enabled: !state.isLoading);
      },
    );
  }
}
