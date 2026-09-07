import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.hintText = AppString.search,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.focusNode,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _clear() {
    _controller.clear();
    widget.onClear?.call();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);

    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        focusNode: widget.focusNode,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        textInputAction: TextInputAction.search,
        style: TextStyle(
          fontSize: 14.sp,
          color: colors.black,
        ),
        decoration: _buildDecoration(colors),
      ),
    );
  }

  InputDecoration _buildDecoration(AppColors colors) {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: TextStyle(
        fontSize: 16.sp,
        color: colors.grey.shade800,
      ),
      prefixIcon: Icon(
        AppIcons.search,
        size: 24.w,
        color: colors.grey.shade700,
      ),
      suffixIcon: _controller.text.isNotEmpty
          ? IconButton(
        onPressed: _clear,
        icon: Icon(
          AppIcons.close,
          size: 24.w,
          color: colors.grey.shade700,
        ),
      )
          : null,
      filled: true,
      fillColor: colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
          color: colors.grey.shade600,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
          color: colors.grey.shade600,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
          color: colors.pink,
          width: 1.5.w,
        ),
      ),
    );
  }
}