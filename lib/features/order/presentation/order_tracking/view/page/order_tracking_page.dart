import 'dart:async';

import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/order_tracking_content.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_action_buttons.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_error_view.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_event.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_state.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_ui_event.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Needs only [orderId]: the view model loads the order and keeps it fresh.
class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key, this.orderId});

  final String? orderId;

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  StreamSubscription<OrderTrackingUiEvent>? _uiEvents;

  @override
  void initState() {
    super.initState();
    _uiEvents = context.read<OrderTrackingViewModel>().uiEvents.listen(_onUiEvent);
  }

  @override
  void dispose() {
    _uiEvents?.cancel();
    super.dispose();
  }

  void _onUiEvent(OrderTrackingUiEvent event) {
    switch (event) {
      case ShowTrackingMessage(:final message):
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.trackingOrder)),
      body: SafeArea(
        child: BlocBuilder<OrderTrackingViewModel, OrderTrackingState>(
          builder: (_, state) => _OrderTrackingBody(
            tracking: state.tracking,
            errorMessage: state.errorMessage,
            isConfirmingDelivery: state.isConfirmingDelivery,
            onShowMap: () => context.push(
              AppRoutesName.orderTrackingMapPage,
              extra: context.read<OrderTrackingViewModel>(),
            ),
            onOrderDelivered: () => context
                .read<OrderTrackingViewModel>()
                .onEvent(ConfirmOrderDelivered()),
            onRetry: () => context
                .read<OrderTrackingViewModel>()
                .onEvent(LoadOrderTracking(widget.orderId)),
          ),
        ),
      ),
    );
  }
}

class _OrderTrackingBody extends StatelessWidget {
  const _OrderTrackingBody({
    required this.tracking,
    required this.errorMessage,
    required this.isConfirmingDelivery,
    required this.onShowMap,
    required this.onOrderDelivered,
    required this.onRetry,
  });

  final TrackingEntity? tracking;
  final String errorMessage;
  final bool isConfirmingDelivery;
  final VoidCallback onShowMap;
  final VoidCallback onOrderDelivered;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = tracking;
    if (t == null) {
      if (errorMessage.isNotEmpty) {
        return TrackingErrorView(message: errorMessage, onRetry: onRetry);
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
