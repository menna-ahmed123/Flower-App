import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Show map" while there is a driver to follow; "Order Delivered" only while
/// the customer must confirm. With neither, it renders nothing.
class TrackingActionButtons extends StatelessWidget {
  const TrackingActionButtons({
    super.key,
    required this.onShowMap,
    required this.onOrderDelivered,
    required this.showOrderDelivered,
    this.showMap = true,
    this.isConfirming = false,
  });

  final VoidCallback onShowMap;
  final VoidCallback onOrderDelivered;
  final bool showOrderDelivered;
  final bool showMap;

  /// Shows AppButton's spinner and disables the button.
  final bool isConfirming;

  @override
  Widget build(BuildContext context) {
    if (!showMap && !showOrderDelivered) return const SizedBox.shrink();

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Row(
        children: [
          if (showMap)
            Expanded(
              child: AppButton(text: AppString.showMap, onPressed: onShowMap),
            ),
          if (showMap && showOrderDelivered) SizedBox(width: 12.w),
          if (showOrderDelivered)
            Expanded(
              child: AppButton(
                text: AppString.orderDelivered,
                isLoading: isConfirming,
                onPressed: onOrderDelivered,
              ),
            ),
        ],
      ),
    );
  }
}
