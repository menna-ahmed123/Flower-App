import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

/// Pink label pill + pin, like "Flowery" / "Apartment" in the Figma.
class TrackingMapPin extends StatelessWidget {
  const TrackingMapPin({
    super.key,
    required this.label,
    this.icon = Icons.storefront,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final pink = context.colors.pink;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 80),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: pink,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: Colors.white),
              const SizedBox(width: 2),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.location_on, color: pink, size: 28),
      ],
    );
  }
}
