import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    required this.color,
    this.backgroundColor,
    this.borderColor,
  });

  final String text;
  final VoidCallback? onTap;
  final Color color;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        side: borderColor != null
            ? WidgetStatePropertyAll(BorderSide(color: borderColor!, width: 1))
            : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
