import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable gender radio group (Female / Male), themed with the app's pink.
class GenderSelector extends StatelessWidget {
  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  final String? selectedGender;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Text(
          AppString.gender,
          style: TextStyle(
            color: colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 16.w),
        _buildOption(context, AppString.female),
        SizedBox(width: 12.w),
        _buildOption(context, AppString.male),
      ],
    );
  }

  Widget _buildOption(BuildContext context, String label) {
    final colors = context.colors;

    return InkWell(
      onTap: () => onChanged(label),
      borderRadius: BorderRadius.circular(20.r),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: label,
            groupValue: selectedGender,
            activeColor: colors.pink,
            onChanged: onChanged,
          ),
          Text(
            label,
            style: TextStyle(color: colors.black, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
