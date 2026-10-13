import 'dart:math' as math;

import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/driver_marker_icon.dart';
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
    this.headingTarget,
    this.duration = const Duration(milliseconds: 900),
    this.child,
  });

  final GeoPoint position;

  /// Route polyline points. When non-empty the driver is snapped to the line.
  final List<GeoPoint> routePoints;

  /// Where the scooter should LOOK. Typically the customer's destination.
  /// Falls back to the last route point, then to the animation target.
  final GeoPoint? headingTarget;
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

  /// Returns the next waypoint ahead of [snapped] along the route (toward destination).
  /// With a sparse route (0-1 points) there is no segment to follow, so glide
  /// toward the heading target instead of freezing on a zero-distance frame.
  LatLng _nextRoutePoint(LatLng snapped) {
    final route = widget.routePoints;
    if (route.length < 2) {
      final target =
          widget.headingTarget ?? (route.isNotEmpty ? route.last : null);
      return target == null ? snapped : _toLatLng(target);
    }

    // Find which segment snapped sits on
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
    // Return the END of that segment — always toward destination (last point)
    // If already on the last segment, use the final destination point
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

  /// Where the scooter should look: the explicit heading target (the
  /// apartment), else the final route point, else the animation target.
  LatLng get _lookAt {
    final GeoPoint? target =
        widget.headingTarget ??
        (widget.routePoints.isNotEmpty ? widget.routePoints.last : null);
    return target != null ? _toLatLng(target) : _to;
  }

  /// The scooter is a SIDE-view sprite (drawn facing left / west), so it must
  /// stay upright. Rotating it ~180° would put it on its head, so instead we
  /// mirror it horizontally to face the apartment's side (east/west).
  bool get _facesEast {
    final dlng = _lookAt.longitude - _current.longitude;
    // Exactly overhead: keep the art's natural west-facing pose.
    if (dlng == 0) return false;
    return dlng > 0;
  }

  /// A gentle nose-up/nose-down tilt that follows the route's slope, capped so
  /// the scooter never tips over. Sign accounts for the horizontal mirroring.
  double get _tiltRad {
    final dlng = _lookAt.longitude - _current.longitude;
    final dlat = _lookAt.latitude - _current.latitude;
    if (dlng == 0 && dlat == 0) return 0;
    final slope = math.atan2(dlat, dlng.abs()); // +ve = target is north
    final east = _facesEast;
    final tilt = east ? -slope : slope;
    return tilt.clamp(-0.45, 0.45);
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
      builder: (_, _) => MarkerLayer(
        markers: [
          Marker(
            point: _current,
            width: 48,
            height: 48,
            child: Transform.rotate(
              angle: _tiltRad,
              child: Transform.flip(
                // Art is drawn facing west; mirror it to look east.
                flipX: _facesEast,
                child: widget.child ?? const DriverMarkerIcon(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
