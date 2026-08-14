import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.suffixIcon,
    this.onChanged,
    this.readOnly = false,
    this.maxLines = 1,
    this.initialValue,
    this.onTap,
  });

  final String label;
  final String? hint;

  final TextEditingController? controller;
  final String? Function(String?)? validator;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final bool isPassword;
  final bool readOnly;

  final int maxLines;
  final String? initialValue;

  final Widget? suffixIcon;

  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword && _isObscure,
      readOnly: widget.readOnly,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      cursorColor: colors.pink,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
                icon: Icon(
                  _isObscure ? AppIcons.visibilityOff : AppIcons.visibility,
                ),
              )
            : widget.suffixIcon,
      ),
    );
  }
}
