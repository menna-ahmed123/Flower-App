import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterSyncedTextField extends StatefulWidget {
  const RegisterSyncedTextField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.decoration,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffixIcon,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final InputDecoration decoration;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  State<RegisterSyncedTextField> createState() => RegisterSyncedTextFieldState();
}

class RegisterSyncedTextFieldState extends State<RegisterSyncedTextField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(RegisterSyncedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != controller.text) controller.text = widget.value;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      decoration: widget.decoration.copyWith(
        suffixIcon: widget.suffixIcon,
        errorText: widget.errorText,
      ),
    );
  }
}

class RegisterNameFields extends StatelessWidget {
  const RegisterNameFields({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.enabled,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    this.firstNameError,
    this.lastNameError,
  });

  final String firstName;
  final String lastName;
  final bool enabled;
  final ValueChanged<String> onFirstNameChanged;
  final ValueChanged<String> onLastNameChanged;
  final String? firstNameError;
  final String? lastNameError;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: firstNameField()),
        SizedBox(width: 12.w),
        Expanded(child: lastNameField()),
      ],
    );
  }

  Widget firstNameField() {
    return RegisterSyncedTextField(
      value: firstName,
      onChanged: onFirstNameChanged,
      enabled: enabled,
      errorText: firstNameError,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: AppString.firstName,
        hintText: AppString.enterFirstName,
      ),
    );
  }

  Widget lastNameField() {
    return RegisterSyncedTextField(
      value: lastName,
      onChanged: onLastNameChanged,
      enabled: enabled,
      errorText: lastNameError,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: AppString.lastName,
        hintText: AppString.enterLastName,
      ),
    );
  }
}

class RegisterEmailField extends StatelessWidget {
  const RegisterEmailField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.enabled,
    this.errorText,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return RegisterSyncedTextField(
      value: value,
      onChanged: onChanged,
      enabled: enabled,
      errorText: errorText,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: AppString.email,
        hintText: AppString.enterYourEmail,
      ),
    );
  }
}

class RegisterPhoneField extends StatelessWidget {
  const RegisterPhoneField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.enabled,
    this.errorText,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return RegisterSyncedTextField(
      value: value,
      onChanged: onChanged,
      enabled: enabled,
      errorText: errorText,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        labelText: AppString.phoneNumber,
        hintText: AppString.enterPhoneNumber,
      ),
    );
  }
}

class RegisterPasswordVisibilityIcon extends StatelessWidget {
  const RegisterPasswordVisibilityIcon({
    super.key,
    required this.obscureText,
    required this.enabled,
    required this.onToggle,
  });

  final bool obscureText;
  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onToggle : null,
      icon: Icon(
        obscureText ? AppIcons.visibilityOff : Icons.visibility_outlined,
        size: 20.sp,
      ),
    );
  }
}

class RegisterPasswordField extends StatelessWidget {
  const RegisterPasswordField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.hint,
    required this.obscureText,
    required this.enabled,
    required this.onToggle,
    this.errorText,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String label;
  final String hint;
  final bool obscureText;
  final bool enabled;
  final VoidCallback onToggle;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return RegisterSyncedTextField(
      value: value,
      onChanged: onChanged,
      obscureText: obscureText,
      enabled: enabled,
      errorText: errorText,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(labelText: label, hintText: hint),
      suffixIcon: RegisterPasswordVisibilityIcon(
        obscureText: obscureText,
        enabled: enabled,
        onToggle: onToggle,
      ),
    );
  }
}

class RegisterPasswordFields extends StatelessWidget {
  const RegisterPasswordFields({
    super.key,
    required this.password,
    required this.confirmPassword,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    this.passwordError,
    this.confirmPasswordError,
  });

  final String password;
  final String confirmPassword;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String? passwordError;
  final String? confirmPasswordError;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmPasswordChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: passwordField()),
        SizedBox(width: 12.w),
        Expanded(child: confirmPasswordField()),
      ],
    );
  }

  Widget passwordField() {
    return RegisterPasswordField(
      value: password,
      onChanged: onPasswordChanged,
      label: AppString.password,
      hint: AppString.enterPassword,
      obscureText: obscurePassword,
      enabled: true,
      onToggle: onTogglePassword,
      errorText: passwordError,
    );
  }

  Widget confirmPasswordField() {
    return RegisterPasswordField(
      value: confirmPassword,
      onChanged: onConfirmPasswordChanged,
      label: AppString.confirmPassword,
      hint: AppString.confirmPassword,
      obscureText: obscureConfirmPassword,
      enabled: true,
      onToggle: onToggleConfirmPassword,
      errorText: confirmPasswordError,
    );
  }
}

