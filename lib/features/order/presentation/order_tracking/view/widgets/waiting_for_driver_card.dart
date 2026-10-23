import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaitingForDriverCard extends StatefulWidget {
  const WaitingForDriverCard({super.key});

  @override
  State<WaitingForDriverCard> createState() => _WaitingForDriverCardState();
}

class _WaitingForDriverCardState extends State<WaitingForDriverCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pink = context.colors.pink;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: Tween<double>(begin: 0.55, end: 1).animate(_pulse),
          child: Container(
            width: 88.r,
            height: 88.r,
            decoration: BoxDecoration(
              color: pink.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.delivery_dining, size: 44.r, color: pink),
          ),
        ),
        SizedBox(height: 20.h),
        const Text(
          AppString.waitingForDriver,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        SizedBox(height: 8.h),
        Text(
          AppString.findingDriver,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: context.colors.grey.shade700),
        ),
      ],
    );
  }
}
