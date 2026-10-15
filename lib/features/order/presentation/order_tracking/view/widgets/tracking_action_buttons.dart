import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Show map" always; "Order Delivered" only while the customer must confirm.
class TrackingActionButtons extends StatelessWidget {
  const TrackingActionButtons({
    super.key,
    required this.onShowMap,
    required this.onOrderDelivered,
    required this.showOrderDelivered,
    this.isConfirming = false,
  });

  final VoidCallback onShowMap;
  final VoidCallback onOrderDelivered;
  final bool showOrderDelivered;

  /// Shows AppButton's spinner and disables the button.
  final bool isConfirming;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Row(
        children: [
          Expanded(child: AppButton(text: AppString.showMap, onPressed: onShowMap)),
          if (showOrderDelivered) ...[
            SizedBox(width: 12.w),
            Expanded(
              child: AppButton(
                text: AppString.orderDelivered,
                isLoading: isConfirming,
                onPressed: onOrderDelivered,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
