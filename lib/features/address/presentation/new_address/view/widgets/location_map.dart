import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMap extends StatefulWidget {
  final LatLng initialLocation;
  final Function(LatLng)? onLocationSelected;

  const LocationMap({
    super.key,
    required this.initialLocation,
    this.onLocationSelected,
  });

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
      final apiKey = dotenv.env['MAPTILER_API_KEY'];

    return FlutterMap(
      options: MapOptions(
        initialCenter: widget.initialLocation,
        initialZoom: 13,
        onTap: (tapPosition, point) {
          setState(() {
            selectedLocation = point;
          });

          widget.onLocationSelected?.call(point);
        },
      ),
      children: [
     
TileLayer(
  urlTemplate:
      'https://api.maptiler.com/maps/streets-v4/{z}/{x}/{y}.png?key=$apiKey&language=en',
      // 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'

          userAgentPackageName: 'com.example.flower_app',
        ),
        //====== for select my store======//
        // PolygonLayer(
        //     polygons: [
        //       Polygon(
        //         points: const [
        //           LatLng(30.0500, 31.2300),
        //           LatLng(30.0600, 31.2400),
        //           LatLng(30.0500, 31.2500),
        //           LatLng(30.0400, 31.2450),
        //           LatLng(30.0350, 31.2350),
        //         ],
        //         color: Colors.pink.withOpacity(0.3),
        //         borderColor: Colors.pink,
        //         borderStrokeWidth: 3,
        //       ),
        //     ],
        //   ),
        MarkerLayer(
          markers: selectedLocation == null
              ? []
              : [
                  Marker(
                    point: selectedLocation!,
                    width: 80,
                    height: 80,
                    child: Icon(
                      Icons.location_pin,
                      size: 50,
                      color: context.colors.pink,
                    ),
                  ),
                ],
        ),
      ],
    );
  }
}
