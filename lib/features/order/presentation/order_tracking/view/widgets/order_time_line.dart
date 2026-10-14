import 'package:flower_app/features/order/presentation/order_tracking/view/extensions/order_status_tracking_label.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/extensions/tracking_date_format.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/extensions/tracking_timeline_steps.dart';
import 'package:flutter/material.dart';

import 'package:flower_app/features/order/core/animation/order_time_line.dart';

/// The tracking steps, painted by [AnimatedOrderTimeline].
class OrderTimeLine extends StatelessWidget {
  const OrderTimeLine({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  final List<TrackingTimelineStep> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return AnimatedOrderTimeline(
      currentStep: currentStep,
      steps: [
        for (final step in steps)
          (
            title: step.status.trackingLabel,
            time: step.occurredAt?.trackingTimelineLabel ?? '',
          ),
      ],
    );
  }
}
