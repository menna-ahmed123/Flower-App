import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ProfileOptionRow extends StatelessWidget {
  const ProfileOptionRow({
    super.key,
    required this.label,
    this.icon,
    this.leading,
    this.trailing,
    this.onTap,
    this.showChevron = true,
  }) : assert(
         icon == null || leading == null,
         'Provide either icon or leading, not both.',
       );

  final String label;
  final IconData? icon;

  /// Custom leading widget (e.g. a [Switch]) shown instead of [icon].
  final Widget? leading;

  /// Custom trailing widget shown before the chevron (e.g. a value label).
  final Widget? trailing;

  final VoidCallback? onTap;

  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 9.h),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              SizedBox(width: 4.w),
            ] else if (icon != null) ...[
              Icon(icon, size: 20.w, color: colors.black),
              SizedBox(width: 4.w),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: colors.black,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (trailing != null) trailing!,
            if (showChevron) ...[
              SizedBox(width: 4.w),
              Icon(AppIcons.chevronRight, size: 24.w, color: colors.grey.shade900),
            ],
          ],
        ),
      ),
    );
  }
}
