import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class MapBackButton extends StatelessWidget {
  const MapBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // One widget for both the circular background and the tap target:
    // an IconButton wrapped in a CircleAvatar double-pads and shrinks the
    // splash.
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: context.colors.white,
        shape: const CircleBorder(),
      ),
      icon: Icon(Icons.arrow_back, color: context.colors.black),
    );
  }
}
