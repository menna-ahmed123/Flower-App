import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersErrorView extends StatelessWidget {
  const OrdersErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 12.h),
          TextButton(onPressed: onRetry, child: Text(AppString.retry)),
        ],
      ),
    );
  }
}
