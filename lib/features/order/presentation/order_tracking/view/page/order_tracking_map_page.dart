import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/map_back_button.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/no_driver_map_banner.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/staleness_badge.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_bottom_panel.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_map.dart';
import 'package:flutter/material.dart';

/// Pure UI. [mapTileLayer] is the app's flutter_map TileLayer (with the API key).
class OrderTrackingMapPage extends StatelessWidget {
  const OrderTrackingMapPage({
    super.key,
    required this.onBack,
    required this.onOrderDetails,
    this.tracking,
    this.routePoints = const [],
    this.mapTileLayer,
  });

  final TrackingEntity? tracking;
  final List<GeoPoint> routePoints;
  final Widget? mapTileLayer;
  final VoidCallback onBack;
  final VoidCallback onOrderDetails;

  @override
  Widget build(BuildContext context) {
    final t = tracking;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: t == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: TrackingMap(
                    driver: t.driverLocation?.point,
                    store: t.storeLocation,
                    home: t.destination,
                    routePoints: routePoints,
                    tileLayer: mapTileLayer,
                  ),
                ),
                Positioned(
                  top: topPad + 8,
                  left: 16,
                  child: MapBackButton(onPressed: onBack),
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
          TrackingBottomPanel(tracking: t, onOrderDetails: onOrderDetails),
        ],
      ),
    );
  }
}
