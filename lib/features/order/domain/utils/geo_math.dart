import 'dart:math' as math;

import '../entities/geo_point.dart';

const double _earthRadiusMeters = 6371008.8;
const double _metersPerDegreeLat = _earthRadiusMeters * math.pi / 180;

double haversineDistanceMeters(GeoPoint a, GeoPoint b) {
  final halfLat = _toRadians(b.lat - a.lat) / 2;
  final halfLng = _toRadians(b.lng - a.lng) / 2;
  final h =
      math.sin(halfLat) * math.sin(halfLat) +
      math.cos(_toRadians(a.lat)) *
          math.cos(_toRadians(b.lat)) *
          math.sin(halfLng) *
          math.sin(halfLng);
  return 2 * _earthRadiusMeters * math.asin(math.sqrt(h));
}

/// Shortest distance from a point to a polyline, in meters.
double distanceToPolylineMeters(GeoPoint point, List<GeoPoint> polyline) {
  if (polyline.isEmpty) return double.infinity;
  if (polyline.length == 1) return haversineDistanceMeters(point, polyline.first);
  var best = double.infinity;
  for (var i = 0; i < polyline.length - 1; i++) {
    final d = _distanceToSegmentMeters(point, polyline[i], polyline[i + 1]);
    if (d < best) best = d;
  }
  return best;
}

double _distanceToSegmentMeters(GeoPoint p, GeoPoint a, GeoPoint b) {
  // Project onto a flat east/north plane centred on the segment start;
  // good enough at the few-hundred-metre scale this is used at.
  final x = (p.lng - a.lng) * _metersPerDegreeLat * math.cos(_toRadians(a.lat));
  final y = (p.lat - a.lat) * _metersPerDegreeLat;
  final bx = (b.lng - a.lng) * _metersPerDegreeLat * math.cos(_toRadians(a.lat));
  final by = (b.lat - a.lat) * _metersPerDegreeLat;
  final lengthSq = bx * bx + by * by;
  var t = 0.0;
  if (lengthSq > 0) {
    t = ((x * bx + y * by) / lengthSq).clamp(0.0, 1.0);
  }
  final dx = x - bx * t;
  final dy = y - by * t;
  return math.sqrt(dx * dx + dy * dy);
}

double _toRadians(double degrees) => degrees * math.pi / 180;
