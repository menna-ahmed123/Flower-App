import 'package:flower_app/core/constants/app_constants.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
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
    '${AppConstants.mapTilerBaseUrl}?key=${AppConstants.mapTilerApiKey}&language=en',
      userAgentPackageName: AppConstants.mapUserAgentPackageName,
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
