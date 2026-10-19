import 'package:flower_app/core/widgets/app_map_tile_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

Widget mapLayerHost() => MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 400,
          child: FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(30.04, 31.23),
              initialZoom: 10,
            ),
            children: [AppMapTileLayer()],
          ),
        ),
      ),
    );

void main() {
  testWidgets('renders a TileLayer pointed at OpenStreetMap', (tester) async {
    await tester.pumpWidget(mapLayerHost());

    final layer = tester.widget<TileLayer>(find.byType(TileLayer));
    expect(layer.urlTemplate, contains('tile.openstreetmap.org'));
    expect(layer.urlTemplate, contains('{z}/{x}/{y}'));
  });

  testWidgets('an unreachable tile server leaves blank tiles, not errors',
      (tester) async {
    await tester.pumpWidget(mapLayerHost());

    final provider =
        tester.widget<TileLayer>(find.byType(TileLayer)).tileProvider;
    expect(provider, isA<NetworkTileProvider>());
    expect((provider as NetworkTileProvider).silenceExceptions, isTrue);
  });
}
