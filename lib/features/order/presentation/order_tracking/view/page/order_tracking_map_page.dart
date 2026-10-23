import 'dart:async';

import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/no_driver_map_banner.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/staleness_badge.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_bottom_panel.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_map.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_event.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_state.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_ui_event.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrderTrackingMapPage extends StatefulWidget {
  const OrderTrackingMapPage({super.key, this.mapTileLayer});

  final Widget? mapTileLayer;

  @override
  State<OrderTrackingMapPage> createState() => _OrderTrackingMapPageState();
}

class _OrderTrackingMapPageState extends State<OrderTrackingMapPage> {
  StreamSubscription<OrderTrackingUiEvent>? _uiEvents;

  @override
  void initState() {
    super.initState();
    _uiEvents =
        context.read<OrderTrackingViewModel>().uiEvents.listen(_onUiEvent);
  }

  @override
  void dispose() {
    _uiEvents?.cancel();
    super.dispose();
  }

  void _onUiEvent(OrderTrackingUiEvent event) {
    switch (event) {
      case ShowTrackingMessage():
        break;
      case TrackingNavigateBack():
        final router = GoRouter.maybeOf(context);
        if (router != null && router.canPop()) {
          router.pop();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: BlocBuilder<OrderTrackingViewModel, OrderTrackingState>(
        builder: (_, state) {
          final t = state.tracking;
          if (t == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: TrackingMap(
                        driver: t.mapDriverLocation,
                        store: t.storeLocation,
                        home: t.destination,
                        routePoints: state.routePoints,
                        tileLayer: widget.mapTileLayer,
                      ),
                    ),
                    Positioned(
                      top: topPad + 12,
                      right: 16,
                      child: t.driver == null
                          ? const NoDriverMapBanner()
                          : StalenessBadge(
                              lastUpdate: t.driverLocation?.recordedAt,
                            ),
                    ),
                  ],
                ),
              ),
              TrackingBottomPanel(
                tracking: t,
                onOrderDetails: () => context.read<OrderTrackingViewModel>()
                    .onEvent(OrderDetailsRequested()),
              ),
            ],
          );
        },
      ),
    );
  }
}
