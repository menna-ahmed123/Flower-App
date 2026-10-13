import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/order_tracking_content.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_action_buttons.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Pure UI: shows whatever it is given (loading / error / data).
class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({
    super.key,
    required this.onShowMap,
    required this.onOrderDelivered,
    this.tracking,
    this.isLoading = false,
    this.errorMessage,
    this.isConfirmingDelivery = false,
    this.onRetry,
  });

  final TrackingEntity? tracking;
  final bool isLoading;
  final String? errorMessage;
  final bool isConfirmingDelivery;
  final VoidCallback onShowMap;
  final VoidCallback onOrderDelivered;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.trackingOrder)),
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    final t = tracking;
    if (t == null) {
      if (errorMessage != null && errorMessage!.isNotEmpty) {
        return TrackingErrorView(message: errorMessage!, onRetry: onRetry);
      }
      return const Center(child: CircularProgressIndicator());
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
            isConfirming: isConfirmingDelivery,
          ),
        ),
      ],
    );
  }
}
