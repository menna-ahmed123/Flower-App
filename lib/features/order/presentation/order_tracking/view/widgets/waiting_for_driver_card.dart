import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shown in place of the driver card until a driver accepts the order.
class WaitingForDriverCard extends StatelessWidget {
  const WaitingForDriverCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: context.colors.pink.withValues(alpha: 0.15),
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: context.colors.pink,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Waiting for a driver',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Text(
                "We'll show your delivery hero as soon as one accepts",
                style: TextStyle(
                  color: context.colors.black.shade50,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}