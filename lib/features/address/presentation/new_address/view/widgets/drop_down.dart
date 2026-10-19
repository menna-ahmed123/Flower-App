import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropDown<T> extends StatelessWidget {
  final String labelText;
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool isLoading;
  final bool enabled;

  const DropDown({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      
      items: items,
      onChanged: enabled && !isLoading ? onChanged : null,
      validator: validator,
      isExpanded: true,
      
      hint: Text(
        isLoading ? 'Loading...' : hintText,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14.sp,
        ),
      ),
      decoration: InputDecoration(
        focusColor: context.colors.pink.withOpacity(0.05),
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
        suffixIcon: isLoading
            ? Padding(
                padding: EdgeInsets.all(12.w),
                child: SizedBox(
                  width: 18.w,
                  height: 18.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.colors.pink,
                  ),
                ),
              )
            : null,
      ),
      dropdownColor: context.colors.pink.shade100,
      icon: const Icon(Icons.keyboard_arrow_down),
    );
  }
}
