import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/order/core/animation/animated_car_single_file.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/extensions/tracking_timeline_steps.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/estimated_arrival_section.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/order_time_line.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_driver_section.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/waiting_for_driver_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Scrollable body of the tracking page (everything above the buttons).
class OrderTrackingContent extends StatelessWidget {
  const OrderTrackingContent({super.key, required this.tracking});

  final TrackingEntity tracking;

  @override
  Widget build(BuildContext context) {
    // Nothing to track until a driver accepts, so the whole body waits.
    if (tracking.driver == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: WaitingForDriverCard(),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          EstimatedArrivalSection(
            estimatedArrivalDateTime: tracking.estimatedArrival,
          ),
          SizedBox(height: 40.h),
          TrackingDriverSection(driver: tracking.driver),
          SizedBox(height: 30.h),
          AnimatedCar(
            // Parked once the order is finished.
            playing: !tracking.isFinished,
            width: 340,
            duration: const Duration(milliseconds: 600),
            showRoad: true,
            showSpeedLines: true,
            roadColor: context.colors.grey.shade600,
          ),
          SizedBox(height: 40.h),
          OrderTimeLine(
            steps: tracking.trackingTimeline,
            currentStep: tracking.uiStepIndex,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
