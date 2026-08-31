import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMap extends StatefulWidget {
  final LocationEntity initialLocation;
  final ValueChanged<LocationEntity>? onLocationSelected;

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

    selectedLocation = LatLng(
      widget.initialLocation.latitude,
      widget.initialLocation.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(
          widget.initialLocation.latitude,
          widget.initialLocation.longitude,
        ),
        initialZoom: 13,
        onTap: (tapPosition, point) {
          setState(() {
            selectedLocation = point;
          });

          widget.onLocationSelected?.call(
            LocationEntity(
              latitude: point.latitude,
              longitude: point.longitude,
            ),
          );
        },
      ),
      children: [
        TileLayer(
          urlTemplate:
              '${AppString.mapTilerUrlTemplate}'
              '?key=${AppString.mapTilerApiKey}'
              '&language=${AppString.mapLanguage}',
          userAgentPackageName: AppString.userAgentPackageName,
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
