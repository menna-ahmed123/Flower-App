import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/order_tracking_content.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_action_buttons.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTrackingBody extends StatelessWidget {
  const OrderTrackingBody({
    super.key,
    required this.tracking,
    required this.isLoading,
    required this.errorMessage,
    required this.isConfirmingDelivery,
    required this.onShowMap,
    required this.onOrderDelivered,
    required this.onRetry,
  });

  final TrackingEntity? tracking;
  final bool isLoading;
  final String errorMessage;
  final bool isConfirmingDelivery;
  final VoidCallback onShowMap;
  final VoidCallback onOrderDelivered;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = tracking;
    if (t == null) {
      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      // Not loading and still nothing to show: say so instead of spinning.
      return TrackingErrorView(
        message: errorMessage.isNotEmpty ? errorMessage : AppString.unknown,
        onRetry: onRetry,
      );
    }

    return Column(
      children: [
        Expanded(child: OrderTrackingContent(tracking: t)),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: TrackingActionButtons(
            onShowMap: onShowMap,
            onOrderDelivered: onOrderDelivered,
            showOrderDelivered: t.canConfirmDelivery,
            showMap: t.driver != null,
            isConfirming: isConfirmingDelivery,
          ),
        ),
      ],
    );
  }
}
