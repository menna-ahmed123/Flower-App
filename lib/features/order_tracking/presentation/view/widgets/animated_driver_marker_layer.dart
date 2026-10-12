import 'dart:math' as math;

import 'package:flower_app/features/order_tracking/domain/entities/geo_point.dart';
import 'package:flower_app/features/order_tracking/presentation/view/widgets/driver_marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Marker layer whose marker GLIDES to every new position instead of jumping.
/// If [routePoints] is provided, the marker is snapped onto the nearest segment
/// of the route so it always appears to travel along the road.
class AnimatedDriverMarkerLayer extends StatefulWidget {
  const AnimatedDriverMarkerLayer({
    super.key,
    required this.position,
    this.routePoints = const [],
    this.duration = const Duration(milliseconds: 900),
    this.child,
  });

  final GeoPoint position;

  /// Route polyline points. When non-empty the driver is snapped to the line.
  final List<GeoPoint> routePoints;
  final Duration duration;

  /// Defaults to [DriverMarkerIcon].
  final Widget? child;

  @override
  State<AnimatedDriverMarkerLayer> createState() =>
      _AnimatedDriverMarkerLayerState();
}

class _AnimatedDriverMarkerLayerState extends State<AnimatedDriverMarkerLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late LatLng _from;
  late LatLng _to;

  @override
  void initState() {
    super.initState();
    _from = _snapToRoute(_toLatLng(widget.position));
    _to = _nextRoutePoint(_from);
  }

  LatLng _toLatLng(GeoPoint p) => LatLng(p.lat, p.lng);

  /// Returns the next waypoint after [snapped] along the route.
  /// Falls back to [snapped] itself when the route has fewer than 2 points.
  LatLng _nextRoutePoint(LatLng snapped) {
    final route = widget.routePoints;
    if (route.length < 2) return snapped;
    // Find which segment snapped sits on, then return that segment's far end.
    int bestSeg = 0;
    double bestDist = double.infinity;
    for (int i = 0; i < route.length - 1; i++) {
      final a = _toLatLng(route[i]);
      final b = _toLatLng(route[i + 1]);
      final s = _closestPointOnSegment(snapped, a, b);
      final d = _distSq(snapped, s);
      if (d < bestDist) {
        bestDist = d;
        bestSeg = i;
      }
    }
    return _toLatLng(route[bestSeg + 1]);
  }

  /// Snaps [point] onto the nearest segment of routePoints.
  LatLng _snapToRoute(LatLng point) {
    final route = widget.routePoints;
    if (route.length < 2) return point;

    LatLng best = point;
    double bestDist = double.infinity;

    for (int i = 0; i < route.length - 1; i++) {
      final a = _toLatLng(route[i]);
      final b = _toLatLng(route[i + 1]);
      final snapped = _closestPointOnSegment(point, a, b);
      final d = _distSq(point, snapped);
      if (d < bestDist) {
        bestDist = d;
        best = snapped;
      }
    }
    return best;
  }

  /// Closest point on segment [a]-[b] to [p].
  LatLng _closestPointOnSegment(LatLng p, LatLng a, LatLng b) {
    final dx = b.latitude - a.latitude;
    final dy = b.longitude - a.longitude;
    final lenSq = dx * dx + dy * dy;
    if (lenSq == 0) return a;
    final t = ((p.latitude - a.latitude) * dx +
            (p.longitude - a.longitude) * dy) /
        lenSq;
    final tc = t.clamp(0.0, 1.0);
    return LatLng(a.latitude + tc * dx, a.longitude + tc * dy);
  }

  double _distSq(LatLng a, LatLng b) {
    final dlat = a.latitude - b.latitude;
    final dlng = a.longitude - b.longitude;
    return dlat * dlat + dlng * dlng;
  }

  LatLng get _current {
    final t = Curves.easeInOut.transform(_controller.value);
    return LatLng(
      _from.latitude + (_to.latitude - _from.latitude) * t,
      _from.longitude + (_to.longitude - _from.longitude) * t,
    );
  }

  /// Bearing in radians: 0 = north, increases clockwise.
  double get _bearingRad {
    final dlat = _to.latitude - _from.latitude;
    final dlng = _to.longitude - _from.longitude;
    if (dlat == 0 && dlng == 0) return 0;
    // atan2(dlng, dlat) = 0 when pointing north.
    // The motorcycle SVG faces east by default, so subtract π/2 to align it.
    return math.atan2(dlng, dlat) - math.pi / 2;
  }

  @override
  void didUpdateWidget(covariant AnimatedDriverMarkerLayer old) {
    super.didUpdateWidget(old);
    if (old.position != widget.position) {
      _from = _current;
      _to = _snapToRoute(_toLatLng(widget.position));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => MarkerLayer(
        markers: [
          Marker(
            point: _current,
            width: 48,
            height: 48,
            child: Transform.rotate(
              angle: _bearingRad,
              child: widget.child ?? const DriverMarkerIcon(),
            ),
          ),
        ],
      ),
    );
  }
}
