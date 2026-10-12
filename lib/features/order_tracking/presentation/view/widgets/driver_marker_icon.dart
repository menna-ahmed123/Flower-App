import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

/// The delivery hero on the map (Figma: scooter). Swap the Icon for the
/// scooter asset when we have it.
class DriverMarkerIcon extends StatelessWidget {
  const DriverMarkerIcon({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.pink,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
      ),
      child: Icon(Icons.two_wheeler, color: Colors.white, size: size * 0.55),
    );
  }
}
