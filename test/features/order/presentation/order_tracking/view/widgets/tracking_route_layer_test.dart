import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_route_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../helpers/pump_app.dart';

Widget _map(List<GeoPoint> points) => Scaffold(
      body: SizedBox(
        width: 400,
        height: 400,
        child: FlutterMap(
          options: const MapOptions(initialCenter: LatLng(30.05, 31.23), initialZoom: 12),
          children: [TrackingRouteLayer(points: points)],
        ),
      ),
    );

void main() {
  testWidgets('draws one polyline with every route point', (tester) async {
    await pumpApp(
      tester,
      _map(const [GeoPoint(30.05, 31.23), GeoPoint(30.055, 31.24), GeoPoint(30.06, 31.26)]),
    );
    final layer = tester.widget<PolylineLayer>(
      find.byWidgetPredicate((w) => w is PolylineLayer),
    );
    expect(layer.polylines, hasLength(1));
    expect(layer.polylines.first.points, hasLength(3));
  });

  testWidgets('fewer than two points draws nothing', (tester) async {
    await pumpApp(tester, _map(const [GeoPoint(30.05, 31.23)]));
    expect(find.byWidgetPredicate((w) => w is PolylineLayer), findsNothing);
  });
}
