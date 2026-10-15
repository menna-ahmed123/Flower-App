import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/map_back_button.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/no_driver_map_banner.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/staleness_badge.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_bottom_panel.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_map.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_state.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Full-screen map of the order the [OrderTrackingViewModel] above is holding.
class OrderTrackingMapPage extends StatelessWidget {
  const OrderTrackingMapPage({super.key, this.mapTileLayer});

  final Widget? mapTileLayer;

  /// Order details has no route in the app yet, so there is nothing to open.
  void _onOrderDetails() {
    // TODO(order-details-route): open the order details for this order id.
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
                        driver: t.driverLocation?.point,
                        store: t.storeLocation,
                        home: t.destination,
                        routePoints: state.routePoints,
                        tileLayer: mapTileLayer,
                      ),
                    ),
                    Positioned(
                      top: topPad + 8,
                      left: 16,
                      child: MapBackButton(onPressed: () => context.pop()),
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
              TrackingBottomPanel(tracking: t, onOrderDetails: _onOrderDetails),
            ],
          );
        },
      ),
    );
  }
}
