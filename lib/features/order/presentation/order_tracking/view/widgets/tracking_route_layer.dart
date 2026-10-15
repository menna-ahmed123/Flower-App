import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// The pink line from the store to the home. Draws nothing for < 2 points.
class TrackingRouteLayer extends StatelessWidget {
  const TrackingRouteLayer({super.key, required this.points});

  final List<GeoPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return const SizedBox.shrink();
    return PolylineLayer(
      polylines: [
        Polyline(
          points: [for (final p in points) LatLng(p.lat, p.lng)],
          strokeWidth: 4,
          color: context.colors.pink,
        ),
      ],
    );
  }
}
