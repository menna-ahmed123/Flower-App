import 'package:flower_app/features/order_tacking/domain/entities/geo_point.dart';
import 'package:flower_app/features/order_tacking/presentation/view/widgets/animated_driver_marker_layer.dart';
import 'package:flower_app/features/order_tacking/presentation/view/widgets/tracking_map_pin.dart';
import 'package:flower_app/features/order_tacking/presentation/view/widgets/tracking_route_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Store -> home route + the moving driver, on flutter_map.
///
/// [tileLayer]: pass the TileLayer the app already uses (the one carrying the
/// API key). The default is public OpenStreetMap tiles: fine for development
/// only, OSM's tile usage policy forbids heavy production use.
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
    if (pts.length >= 2 && _fitKey != _lastFitKey) {
      _lastFitKey = _fitKey;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _controller.fitCamera(
          CameraFit.coordinates(coordinates: pts, padding: _fitPadding),
        );
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
        initialZoom: 14,
        initialCameraFit: pts.length >= 2
            ? CameraFit.coordinates(coordinates: pts, padding: _fitPadding)
            : null,
      ),
      children: [
        widget.tileLayer ??
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.flower_app',
            ),
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
        if (driver != null) AnimatedDriverMarkerLayer(position: driver),
      ],
    );
  }
}
