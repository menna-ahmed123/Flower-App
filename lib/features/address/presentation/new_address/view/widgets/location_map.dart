import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMap extends StatefulWidget {
  final LatLng initialLocation;
  final ValueChanged<LatLng>? onLocationSelected;

  const LocationMap({
    super.key,
    required this.initialLocation,
    this.onLocationSelected,
  });

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  late LatLng selectedLocation;

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
          userAgentPackageName: 'com.example.flower_app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: selectedLocation,
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
