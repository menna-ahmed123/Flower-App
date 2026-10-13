import 'package:flower_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// The app's MapTiler tile layer. Same URL/key/user-agent that LocationMap
/// already uses (copied from it), so every map in the app shares one config.
/// (Optional follow-up: make LocationMap use this widget too.)
class AppMapTileLayer extends StatelessWidget {
  const AppMapTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    // Using OpenStreetMap (free, no API key needed)
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.flower_app',
    );
  }
}
