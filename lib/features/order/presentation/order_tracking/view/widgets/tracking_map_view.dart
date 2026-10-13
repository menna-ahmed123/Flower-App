import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_map_tile_layer.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TrackingMapView extends StatefulWidget {
  const TrackingMapView({
    super.key,
    this.driver,
    this.store,
    this.home,
    this.route = const [],
    this.tileLayer,
  });

  final GeoPoint? driver;
  final GeoPoint? store;
  final GeoPoint? home;
  final List<GeoPoint> route;
  final Widget? tileLayer;

  @override
  State<TrackingMapView> createState() => _TrackingMapViewState();
}

class _TrackingMapViewState extends State<TrackingMapView>
    with SingleTickerProviderStateMixin {
  static const _cairo = LatLng(30.0444, 31.2357);

  final MapController _map = MapController();
  final ValueNotifier<LatLng?> _shownDriver = ValueNotifier(null);

  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..addListener(_onTick);

  LatLng? _from;
  LatLng? _to;

  bool _mapReady = false;
  bool _fitted = false;
  bool _fitPending = false;

  LatLng? _ll(GeoPoint? point) {
    return point == null ? null : LatLng(point.lat, point.lng);
  }

  @override
  void initState() {
    super.initState();
    _shownDriver.value = _ll(widget.driver);
  }

  void _onTick() {
    final start = _from;
    final end = _to;

    if (start == null || end == null) return;

    final t = Curves.easeInOut.transform(_anim.value);

    _shownDriver.value = LatLng(
      start.latitude + (end.latitude - start.latitude) * t,
      start.longitude + (end.longitude - start.longitude) * t,
    );
  }

  @override
  void didUpdateWidget(covariant TrackingMapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    final next = _ll(widget.driver);
    final previous = _ll(oldWidget.driver);

    if (next != previous) {
      if (next == null) {
        _anim.stop();
        _from = null;
        _to = null;
        _shownDriver.value = null;
      } else if (_shownDriver.value == null) {
        _anim.stop();
        _from = null;
        _to = null;
        _shownDriver.value = next;
      } else {
        _from = _shownDriver.value;
        _to = next;
        _anim.forward(from: 0);
      }
    }

    if (widget.store != oldWidget.store ||
        widget.home != oldWidget.home ||
        widget.driver != oldWidget.driver) {
      _requestFit();
    }
  }

  void _requestFit() {
    _fitted = false;
    _fitPending = true;

    if (!_mapReady) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fitIfNeeded();
    });
  }

  void _fitIfNeeded() {
    if (!_mapReady || !_fitPending || _fitted) return;

    final points = [
      _ll(widget.store),
      _ll(widget.home),
      _shownDriver.value ?? _ll(widget.driver),
    ].whereType<LatLng>().toList();

    if (points.isEmpty) return;

    if (points.length == 1) {
      _map.move(points.first, 15);
    } else {
      final bounds = LatLngBounds.fromPoints(points);

      _map.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(70),
          maxZoom: 15,
        ),
      );
    }

    _fitted = true;
    _fitPending = false;
  }

  List<LatLng> get _linePoints {
    if (widget.route.length >= 2) {
      return widget.route.map((point) {
        return LatLng(point.lat, point.lng);
      }).toList();
    }

    final start = _ll(widget.store) ?? _ll(widget.driver);
    final end = _ll(widget.home);

    return start != null && end != null ? [start, end] : [];
  }

  Widget _buildMarker(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Tooltip(
      message: label,
      child: Icon(
        icon,
        color: color,
        size: 38,
        shadows: [
          Shadow(
            color: context.colors.black.withValues(alpha: 0.26),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverMarker(BuildContext context) {
    return ValueListenableBuilder<LatLng?>(
      valueListenable: _shownDriver,
      builder: (context, driverPosition, child) {
        if (driverPosition == null) {
          return const SizedBox.shrink();
        }

        return MarkerLayer(
          markers: [
            Marker(
              point: driverPosition,
              width: 100,
              height: 60,
              child: child!,
            ),
          ],
        );
      },
      child: _buildMarker(
        context,
        icon: Icons.delivery_dining,
        color: Colors.blue,
        label: 'Your delivery hero',
      ),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    _shownDriver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = _ll(widget.store);
    final home = _ll(widget.home);
    final line = _linePoints;

    return FlutterMap(
      mapController: _map,
      options: MapOptions(
        initialCenter: home ?? store ?? _ll(widget.driver) ?? _cairo,
        initialZoom: 13,
        onMapReady: () {
          _mapReady = true;
          _fitIfNeeded();
        },
      ),
      children: [
        widget.tileLayer ?? const AppMapTileLayer(),
        if (line.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: line,
                strokeWidth: 4,
                color: context.colors.pink,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (store != null)
              Marker(
                point: store,
                width: 100,
                height: 60,
                child: _buildMarker(
                  context,
                  icon: Icons.store,
                  color: context.colors.pink,
                  label: 'Flowery store',
                ),
              ),
            if (home != null)
              Marker(
                point: home,
                width: 100,
                height: 60,
                child: _buildMarker(
                  context,
                  icon: Icons.home,
                  color: context.colors.pink,
                  label: 'Delivery address',
                ),
              ),
          ],
        ),
        _buildDriverMarker(context),
      ],
    );
  }
}
