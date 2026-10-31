import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/estimated_arrival_section.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_driver_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Bottom of the map page: ETA, driver (or "no driver"), Order details.
class TrackingBottomPanel extends StatelessWidget {
  const TrackingBottomPanel({
    super.key,
    required this.tracking,
    required this.onOrderDetails,
  });

  final TrackingEntity tracking;
  final VoidCallback onOrderDetails;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const EstimatedArrivalSection(),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TrackingDriverSection(driver: tracking.driver),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AppButton(text: AppString.trackingOrderDetails, onPressed: onOrderDetails),
            ),
          ],
        ),
      ),
    );
  }
}
