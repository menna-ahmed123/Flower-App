import 'dart:async';

import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

/// How fresh the driver's location is. Ticks on its own timer so the text
/// keeps ageing between polls without the view model emitting anything.
class StalenessBadge extends StatefulWidget {
  const StalenessBadge({super.key, required this.lastUpdate});

  /// `recordedAt` of the driver's last known location (UTC).
  final DateTime? lastUpdate;

  static const freshFor = Duration(seconds: 60);
  static const staleAfter = Duration(minutes: 3);

  @override
  State<StalenessBadge> createState() => _StalenessBadgeState();
}

class _StalenessBadgeState extends State<StalenessBadge> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _ago(Duration d) {
    if (d.inSeconds < 60) return '${d.inSeconds}s ago';
    if (d.inMinutes < 60) return '${d.inMinutes} min ago';
    return '${d.inHours} h ago';
  }

  @override
  Widget build(BuildContext context) {
    final last = widget.lastUpdate;
    if (last == null) {
      return _pill(context, context.colors.grey, AppString.waitingForLocation);
    }

    var age = DateTime.now().toUtc().difference(last.toUtc());
    if (age.isNegative) age = Duration.zero; // device clock slightly behind

    if (age < StalenessBadge.freshFor) {
      return _pill(context, context.colors.green, AppString.liveLocation);
    }
    if (age < StalenessBadge.staleAfter) {
      return _pill(context, context.colors.warning, 'Updated ${_ago(age)}');
    }
    return _pill(context, context.colors.error, 'Location outdated · ${_ago(age)}');
  }

  Widget _pill(BuildContext context, Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
