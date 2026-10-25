import 'dart:async';

import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/order_tracking_body.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_event.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_state.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_ui_event.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
      // Owned by the map page stacked above this one; popping here too would
      // unwind two routes for a single tap.
      case TrackingNavigateBack():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.trackingOrder)),
      body: SafeArea(
        child: BlocBuilder<OrderTrackingViewModel, OrderTrackingState>(
          builder: (_, state) => OrderTrackingBody(
            tracking: state.tracking,
            isLoading: state.isLoading,
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
