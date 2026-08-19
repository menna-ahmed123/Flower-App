import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart'
    show Gender;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterGenderSelector extends StatelessWidget {
  const RegisterGenderSelector({
    super.key,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final Gender value;
  final bool enabled;
  final ValueChanged<Gender> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        genderLabel(context),
        SizedBox(width: 24.w),
        femaleOption(),
        SizedBox(width: 20.w),
        maleOption(),
      ],
    );
  }

  Widget genderLabel(BuildContext context) {
    return Text(
      AppString.gender,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
    );
  }

  Widget femaleOption() {
    return RegisterGenderOption(
      label: AppString.female,
      selected: value == Gender.female,
      enabled: enabled,
      onTap: () => onChanged(Gender.female),
    );
  }

  Widget maleOption() {
    return RegisterGenderOption(
      label: AppString.male,
      selected: value == Gender.male,
      enabled: enabled,
      onTap: () => onChanged(Gender.male),
    );
  }
}

class RegisterGenderOption extends StatelessWidget {
  const RegisterGenderOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.enabled,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(20.r),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RegisterGenderDot(selected: selected),
          SizedBox(width: 8.w),
          Text(label, style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }
}

class RegisterGenderDot extends StatelessWidget {
  const RegisterGenderDot({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? colors.pink : colors.black[40]!,
          width: 2,
        ),
      ),
      child: selected ? selectedInner(colors) : null,
    );
  }

  Widget selectedInner(AppColors colors) {
    return Center(
      child: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(shape: BoxShape.circle, color: colors.pink),
      ),
    );
  }
}
