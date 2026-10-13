import 'dart:async';

import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

/// How fresh the driver's location is. Ticks on its own timer so the text
/// keeps ageing between polls without the view model emitting anything.
///
/// [now] exists so tests can pass a fixed/steppable clock and hit every
/// staleness branch deterministically instead of racing the wall clock.
class StalenessBadge extends StatefulWidget {
  const StalenessBadge({
    super.key,
    required this.lastUpdate,
    this.now = DateTime.now,
  });

  /// `recordedAt` of the driver's last known location (UTC).
  final DateTime? lastUpdate;
  final DateTime Function() now;

  static const freshFor = Duration(seconds: 60);
  static const staleAfter = Duration(minutes: 3);

  @override
  State<StalenessBadge> createState() => _StalenessBadgeState();
}

class _StalenessBadgeState extends State<StalenessBadge> {
  Timer? _ticker;

  /// The label rendered in the last build; the timer only rebuilds when the
  /// label would actually change (it ages in whole minutes/seconds steps).
  String? _shownLabel;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final next = _label();
      if (next != _shownLabel) setState(() {});
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

  Duration get _age {
    var age = widget.now().toUtc().difference(widget.lastUpdate!.toUtc());
    if (age.isNegative) age = Duration.zero; // device clock slightly behind
    return age;
  }

  /// The text the current clock would show; used to skip no-op rebuilds.
  String _label() {
    final last = widget.lastUpdate;
    if (last == null) return AppString.waitingForLocation;
    final age = _age;
    if (age < StalenessBadge.freshFor) return AppString.liveLocation;
    if (age < StalenessBadge.staleAfter) return 'Updated ${_ago(age)}';
    return 'Location outdated · ${_ago(age)}';
  }

  @override
  Widget build(BuildContext context) {
    final last = widget.lastUpdate;
    if (last == null) {
      _shownLabel = AppString.waitingForLocation;
      return _pill(context, context.colors.grey, AppString.waitingForLocation);
    }

    final age = _age;
    final String text;
    final Color color;
    if (age < StalenessBadge.freshFor) {
      text = AppString.liveLocation;
      color = context.colors.green;
    } else if (age < StalenessBadge.staleAfter) {
      text = 'Updated ${_ago(age)}';
      color = context.colors.warning;
    } else {
      text = 'Location outdated · ${_ago(age)}';
      color = context.colors.error;
    }
    _shownLabel = text;
    return _pill(context, color, text);
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
