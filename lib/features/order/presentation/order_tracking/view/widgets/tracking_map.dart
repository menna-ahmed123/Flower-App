import 'package:flower_app/core/widgets/app_map_tile_layer.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/animated_driver_marker_layer.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_map_pin.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_route_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Store -> home route + the moving driver, on flutter_map.
///
/// [tileLayer]: defaults to [AppMapTileLayer] (MapTiler + the app's key).
/// Tests inject an empty widget so nothing hits the network.
class TrackingMap extends StatefulWidget {
  const TrackingMap({
    super.key,
    this.driver,
    this.store,
    this.home,
    this.routePoints = const [],
    this.tileLayer,
    this.storeLabel = 'Flowery',
    this.homeLabel = 'Apartment',
  });

  final GeoPoint? driver;
  final GeoPoint? store;
  final GeoPoint? home;

  /// Road geometry store -> home. Falls back to a straight line when empty.
  final List<GeoPoint> routePoints;
  final Widget? tileLayer;
  final String storeLabel;
  final String homeLabel;

  @override
  State<TrackingMap> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  static const _cairo = LatLng(30.0444, 31.2357);
  static const _fitPadding = EdgeInsets.fromLTRB(48, 110, 48, 48);

  /// Below this span (degrees, ~50 m) all points are "the same place", e.g.
  /// the seeded store sits exactly on the customer's address. Fitting bounds
  /// of a single spot would zoom to the maximum, so we centre + fixed zoom.
  static const _minSpan = 0.0005;
  static const _singleSpotZoom = 16.0;

  final MapController _controller = MapController();
  String? _lastFitKey;

  LatLng _ll(GeoPoint p) => LatLng(p.lat, p.lng);

  List<GeoPoint> get _line {
    if (widget.routePoints.length >= 2) return widget.routePoints;
    final start = widget.store ?? widget.driver;
    final end = widget.home;
    return (start != null && end != null) ? [start, end] : const [];
  }

  /// Points the camera must contain.
  List<LatLng> get _fitPoints {
    final base = widget.routePoints.length >= 2
        ? widget.routePoints
        : [widget.store, widget.home, widget.driver].whereType<GeoPoint>().toList();
    return base.map(_ll).toList();
  }

  bool _isSingleSpot(List<LatLng> pts) {
    if (pts.length < 2) return false;
    var minLat = pts.first.latitude, maxLat = minLat;
    var minLng = pts.first.longitude, maxLng = minLng;
    for (final p in pts) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    final span = (maxLat - minLat) > (maxLng - minLng)
        ? (maxLat - minLat)
        : (maxLng - minLng);
    return span < _minSpan;
  }

  CameraFit? _cameraFit(List<LatLng> pts) {
    if (pts.length < 2 || _isSingleSpot(pts)) return null;
    return CameraFit.coordinates(coordinates: pts, padding: _fitPadding);
  }

  /// Changes only when the *shape* of the data changes (a point appears, the
  /// route arrives), so a moving driver never re-fits the camera under the user.
  String get _fitKey =>
      '${widget.store != null}|${widget.home != null}|${widget.routePoints.length >= 2}';

  @override
  void initState() {
    super.initState();
    _lastFitKey = _fitPoints.length >= 2 ? _fitKey : null;
  }

  @override
  void didUpdateWidget(covariant TrackingMap old) {
    super.didUpdateWidget(old);
    final pts = _fitPoints;
    if (pts.length < 2) {
      // Forget the last fitted shape so coming back to >=2 points re-fits.
      _lastFitKey = null;
      return;
    }
    if (_fitKey != _lastFitKey) {
      _lastFitKey = _fitKey;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final fit = _cameraFit(pts);
        if (fit != null) {
          _controller.fitCamera(fit);
        } else {
          _controller.move(pts.first, _singleSpotZoom);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pts = _fitPoints;
    final store = widget.store;
    final home = widget.home;
    final driver = widget.driver;

    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: pts.isNotEmpty ? pts.first : _cairo,
        initialZoom: _isSingleSpot(pts) ? _singleSpotZoom : 14,
        initialCameraFit: _cameraFit(pts),
      ),
      children: [
        widget.tileLayer ?? const AppMapTileLayer(),
        TrackingRouteLayer(points: _line),
        MarkerLayer(
          markers: [
            if (store != null)
              Marker(
                point: _ll(store),
                width: 110,
                height: 64,
                alignment: Alignment.topCenter,
                child: TrackingMapPin(
                  label: widget.storeLabel,
                  icon: Icons.storefront,
                ),
              ),
            if (home != null)
              Marker(
                point: _ll(home),
                width: 110,
                height: 64,
                alignment: Alignment.topCenter,
                child: TrackingMapPin(
                  label: widget.homeLabel,
                  icon: Icons.home_outlined,
                ),
              ),
          ],
        ),
        if (driver != null) AnimatedDriverMarkerLayer(
          position: driver,
          routePoints: widget.routePoints,
          // The scooter always looks at the customer's destination.
          headingTarget: home,
        ),
      ],
    );
  }
}
