import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  const CustomAppBar({super.key, required this.title, this.onBack, this.bottom});

  final String title;
  final VoidCallback? onBack;
  final PreferredSizeWidget? bottom;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      bottom: widget.bottom,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: widget.onBack,
            child: Icon(
              AppIcons.arrowBack,
              color: context.colors.black,
              size: 25.w,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            widget.title,
            style: TextStyle(
              color: context.colors.black,
              fontSize: 25.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
