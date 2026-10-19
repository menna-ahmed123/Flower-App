import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/animated_driver_marker_layer.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/driver_marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../fixtures/tracking_fixtures.dart';
import '../../../../../../helpers/pump_app.dart';

/// Host whose position can change WITHOUT rebuilding the whole app, so the
/// layer's State (and its animation) survives, like in the real screen.
Widget _host(ValueNotifier<GeoPoint> position, {Widget? child}) => Scaffold(
      body: SizedBox(
        width: 400,
        height: 400,
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(30.05, 31.24),
            initialZoom: 12,
          ),
          children: [
            ValueListenableBuilder<GeoPoint>(
              valueListenable: position,
              builder: (_, p, _) =>
                  AnimatedDriverMarkerLayer(position: p, child: child),
            ),
          ],
        ),
      ),
    );

LatLng _markerPoint(WidgetTester tester) {
  final layer = tester.widget<MarkerLayer>(
    find.byWidgetPredicate((w) => w is MarkerLayer),
  );
  return layer.markers.single.point;
}

void main() {
  testWidgets('starts exactly at the given position', (tester) async {
    final position = ValueNotifier(const GeoPoint(30.05, 31.23));
    await pumpApp(tester, _host(position));
    expect(find.byType(DriverMarkerIcon), findsOneWidget);
    expect(_markerPoint(tester), const LatLng(30.05, 31.23));
  });

  testWidgets('glides to a new position instead of jumping', (tester) async {
    final position = ValueNotifier(const GeoPoint(30.05, 31.23));
    await pumpApp(tester, _host(position));

    position.value = const GeoPoint(30.06, 31.25);
    await tester.pump(); // rebuild with the new target
    await tester.pump(const Duration(milliseconds: 450)); // ~half of 900ms

    final mid = _markerPoint(tester);
    expect(mid.latitude, greaterThan(30.05));
    expect(mid.latitude, lessThan(30.06)); // in between, not teleported

    await tester.pump(const Duration(milliseconds: 600));
    expect(_markerPoint(tester), const LatLng(30.06, 31.25));
  });

  testWidgets('a second update starts from where the marker is now', (tester) async {
    final position = ValueNotifier(const GeoPoint(30.05, 31.23));
    await pumpApp(tester, _host(position));

    position.value = const GeoPoint(30.06, 31.25);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    final before = _markerPoint(tester);

    position.value = const GeoPoint(30.07, 31.26);
    await tester.pump(); // new animation begins at `before`
    expect(_markerPoint(tester).latitude, closeTo(before.latitude, 0.0005));
  });

  testWidgets('uses a custom child when given', (tester) async {
    final position = ValueNotifier(const GeoPoint(30.05, 31.23));
    await pumpApp(tester, _host(position, child: const Icon(Icons.star)));
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.byType(DriverMarkerIcon), findsNothing);
  });

  // Review: routePoints with fewer than 2 points used to leave a zero-distance
  // first frame. It must not crash and updates must still glide.
  testWidgets('sparse route (single point) still glides to a new position',
      (tester) async {
    final position = ValueNotifier(const GeoPoint(30.05, 31.23));
    await pumpApp(
      tester,
      Scaffold(
        body: SizedBox(
          width: 400,
          height: 400,
          child: FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(30.05, 31.24),
              initialZoom: 12,
            ),
            children: [
              ValueListenableBuilder<GeoPoint>(
                valueListenable: position,
                builder: (_, p, _) => AnimatedDriverMarkerLayer(
                  position: p,
                  routePoints: const [driverPoint],
                  headingTarget: homePoint,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);

    position.value = const GeoPoint(30.06, 31.25);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    final mid = _markerPoint(tester);
    expect(mid.latitude, greaterThan(30.05));
    expect(mid.latitude, lessThan(30.06)); // gliding, not teleporting
  });
}
