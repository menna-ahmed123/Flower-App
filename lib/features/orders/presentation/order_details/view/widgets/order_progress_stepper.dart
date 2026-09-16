import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/orders/domain/entities/order_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Matches the Figma "Track order" header: a single status banner above a thin 4-segment progress line.
class OrderProgressStepper extends StatelessWidget {
  const OrderProgressStepper({super.key, required this.status});

  final OrderStatus status;

  // Maps the six backend statuses onto the four visual milestones shown by the design.
  int get _activeStepIndex {
    return switch (status) {
      OrderStatus.placed => 0,
      OrderStatus.preparing || OrderStatus.pickedUp => 1,
      OrderStatus.outForDelivery => 2,
      OrderStatus.delivered => 3,
      OrderStatus.cancelled => -1,
    };
  }

  String get _statusMessage {
    return switch (status) {
      OrderStatus.placed => AppString.orderPlaced,
      OrderStatus.preparing || OrderStatus.pickedUp => AppString.orderPreparing,
      OrderStatus.outForDelivery => AppString.orderOutForDelivery,
      OrderStatus.delivered => AppString.orderDelivered,
      OrderStatus.cancelled => AppString.orderCancelled,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        Icon(
          status == OrderStatus.cancelled ? Icons.cancel : AppIcons.checkCircle,
          color: status == OrderStatus.cancelled ? colors.error : colors.pink,
          size: 32.w,
        ),
        SizedBox(height: 8.h),
        Text(
          _statusMessage,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: colors.black),
          textAlign: TextAlign.center,
        ),
        if (status != OrderStatus.cancelled) ...[
          SizedBox(height: 24.h),
          _ProgressLine(activeStep: _activeStepIndex),
        ],
      ],
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({required this.activeStep});

  final int activeStep;

  static const _segmentCount = 4;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        for (var i = 0; i < _segmentCount; i++) ...[
          Expanded(
            child: Container(
              height: 3.h,
              decoration: BoxDecoration(
                color: i <= activeStep ? colors.pink : colors.grey.shade400,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          if (i != _segmentCount - 1) SizedBox(width: 8.w),
        ],
      ],
    );
  }
}
