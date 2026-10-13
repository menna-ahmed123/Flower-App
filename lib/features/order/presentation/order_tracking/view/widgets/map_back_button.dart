import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class MapBackButton extends StatelessWidget {
  const MapBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: context.colors.white,
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: context.colors.black),
        onPressed: onPressed,
      ),
    );
  }
}
