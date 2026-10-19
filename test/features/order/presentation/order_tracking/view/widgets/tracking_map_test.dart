import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/animated_driver_marker_layer.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_map.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_map_pin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/tracking_fixtures.dart';
import '../../../../../../helpers/pump_app.dart';

/// Tiles would hit the network in tests, so inject an empty layer.
Widget _map({
  bool withStore = true,
  bool withHome = true,
  bool withDriver = true,
  List<GeoPoint> routePoints = const [],
}) =>
    Scaffold(
      body: SizedBox(
        width: 400,
        height: 600,
        child: TrackingMap(
          store: withStore ? storePoint : null,
          home: withHome ? homePoint : null,
          driver: withDriver ? driverPoint : null,
          routePoints: routePoints,
          tileLayer: const SizedBox.shrink(),
        ),
      ),
    );

void main() {
  testWidgets('shows both pins with the Figma labels', (tester) async {
    await pumpApp(tester, _map());
    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.byType(TrackingMapPin), findsNWidgets(2));
    expect(find.text('Flowery'), findsOneWidget);
    expect(find.text('Apartment'), findsOneWidget);
  });

  testWidgets('shows the driver marker when there is a driver position', (tester) async {
    await pumpApp(tester, _map());
    expect(find.byType(AnimatedDriverMarkerLayer), findsOneWidget);
  });

  testWidgets('no driver position -> no driver marker, pins still shown', (tester) async {
    await pumpApp(tester, _map(withDriver: false));
    expect(find.byType(AnimatedDriverMarkerLayer), findsNothing);
    expect(find.byType(TrackingMapPin), findsNWidgets(2));
  });

  testWidgets('without a road route it draws a straight store->home line', (tester) async {
    await pumpApp(tester, _map());
    final layer = tester.widget<PolylineLayer>(
      find.byWidgetPredicate((w) => w is PolylineLayer),
    );
    expect(layer.polylines.first.points, hasLength(2));
  });

  testWidgets('with a road route it draws the whole route', (tester) async {
    await pumpApp(tester, _map(routePoints: [storePoint, driverPoint, homePoint]));
    final layer = tester.widget<PolylineLayer>(
      find.byWidgetPredicate((w) => w is PolylineLayer),
    );
    expect(layer.polylines.first.points, hasLength(3));
  });

  testWidgets('missing store: no store pin, no crash', (tester) async {
    await pumpApp(tester, _map(withStore: false));
    expect(find.text('Flowery'), findsNothing);
    expect(find.text('Apartment'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nothing known yet still builds an empty map', (tester) async {
    await pumpApp(
      tester,
      _map(withStore: false, withHome: false, withDriver: false),
    );
    expect(find.byType(FlutterMap), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
