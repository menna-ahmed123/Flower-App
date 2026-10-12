import 'package:flower_app/features/order_tacking/core/animation/animated_car_single_file.dart';
import 'package:flower_app/features/order_tacking/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order_tacking/presentation/view/widgets/estimated_arrival_section.dart';
import 'package:flower_app/features/order_tacking/presentation/view/widgets/order_time_line.dart';
import 'package:flower_app/features/order_tacking/presentation/view/widgets/tracking_driver_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Scrollable body of the tracking page (everything above the buttons).
class OrderTrackingContent extends StatelessWidget {
  const OrderTrackingContent({super.key, required this.tracking});

  final TrackingEntity tracking;

  @override
  Widget build(BuildContext context) {
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
            width: 340,
            duration: const Duration(milliseconds: 600),
            showRoad: true,
            showSpeedLines: true,
            roadColor: const Color(0xFFCFD8DC),
          ),
          SizedBox(height: 40.h),
          OrderTimeLine(
            steps: tracking.uiSteps,
            currentStep: tracking.uiStepIndex,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
