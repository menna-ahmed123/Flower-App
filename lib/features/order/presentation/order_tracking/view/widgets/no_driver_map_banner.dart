import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

/// Replaces the staleness badge on the map while there is no driver.
class NoDriverMapBanner extends StatelessWidget {
  const NoDriverMapBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: context.colors.black.withValues(alpha: 0.26),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_top, size: 14, color: context.colors.warning),
          const SizedBox(width: 6),
          Text(AppString.waitingForDriver, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
