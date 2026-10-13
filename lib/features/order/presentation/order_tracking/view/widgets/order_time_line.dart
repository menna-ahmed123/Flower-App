import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flutter/material.dart';

import 'package:flower_app/features/order/core/animation/order_time_line.dart';

/// Now a dumb widget: no timer, no fetching. The view model owns the polling.
class OrderTimeLine extends StatelessWidget {
  const OrderTimeLine({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  final List<TrackingUiStep> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy - h:mm a');
    return AnimatedOrderTimeline(
      currentStep: currentStep,
      steps: [
        for (final s in steps)
          (
            title: s.title,
            time: s.time == null ? '' : fmt.format(s.time!.toLocal()),
          ),
      ],
    );
  }
}
