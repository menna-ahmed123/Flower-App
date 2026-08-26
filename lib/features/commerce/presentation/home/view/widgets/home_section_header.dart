import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        children: [
          Expanded(child: _title(context)),
          if (onAction != null) _viewAll(context),
        ],
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: context.colors.black,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _viewAll(BuildContext context) {
    return GestureDetector(
      onTap: onAction,
      child: Text(
        actionLabel == null || actionLabel!.isEmpty
            ? AppString.viewAll
            : actionLabel!,
        style: TextStyle(
          color: context.colors.pink,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
