import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class AppMapTileLayer extends StatelessWidget {
  AppMapTileLayer({super.key})
    : _tileProvider = NetworkTileProvider(silenceExceptions: true);

  static const String urlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String userAgentPackageName = 'com.example.flower_app';

  final TileProvider _tileProvider;

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: urlTemplate,
      userAgentPackageName: userAgentPackageName,
      tileProvider: _tileProvider,
    );
  }
}
