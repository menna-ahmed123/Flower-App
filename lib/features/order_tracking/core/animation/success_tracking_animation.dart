import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

/// Animated version of `success_tracking_icon.svg`.
///
/// Sequence: core circle pops in -> rings ripple outward -> checkmark draws.
/// Pure Flutter (CustomPainter), no packages, resolution independent.
///
/// Usage:
/// ```dart
/// const SuccessTrackingAnimation(size: 150)
/// ```
/// Replay / control it yourself:
/// ```dart
/// final c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
/// SuccessTrackingAnimation(controller: c);
/// c.forward(from: 0);
/// ```
class SuccessTrackingAnimation extends StatefulWidget {
  const SuccessTrackingAnimation({
    super.key,
    this.size = 150,
    this.duration = const Duration(milliseconds: 1600),
    this.autoPlay = true,
    this.controller,
    this.onCompleted,
  });

  final double size;
  final Duration duration;

  /// Starts automatically when the widget is first built.
  final bool autoPlay;

  /// Optional external controller (you own and dispose it).
  final AnimationController? controller;

  final VoidCallback? onCompleted;

  @override
  State<SuccessTrackingAnimation> createState() =>
      _SuccessTrackingAnimationState();
}

class _SuccessTrackingAnimationState extends State<SuccessTrackingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ??
        AnimationController(vsync: this, duration: widget.duration);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onCompleted?.call();
    });

    if (widget.autoPlay) _controller.forward();
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) =>
              CustomPaint(painter: _SuccessPainter(_controller.value)),
        ),
      ),
    );
  }
}

class _SuccessPainter extends CustomPainter {
  _SuccessPainter(this.t);

  /// Overall progress 0..1.
  final double t;

  // Colors taken straight from the SVG (outer -> inner).
  static const _ringColors = [
    Color(0xFFE0FDE1),
    Color(0xFFD1FBD3),
    Color(0xFFBDF7BF),
    Color(0xFF94EC97),
  ];
  static const _ringRadii = [75.0, 60.0, 45.0, 30.0];
  static const _checkColor = Color(0xFFF9F9F9);

  // Timeline: (start, end) as fractions of the full duration.
  // Inner circle first, then rings expand outward.
  static const _ringIntervals = [
    (0.30, 0.70), // outermost
    (0.20, 0.60),
    (0.10, 0.50),
    (0.00, 0.40), // core
  ];
  static const _checkInterval = (0.50, 0.90);

  double _phase(double start, double end, Curve curve) {
    final v = ((t - start) / (end - start)).clamp(0.0, 1.0);
    return curve.transform(v);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Work in the SVG's 150x150 coordinate space.
    canvas.scale(size.width / 150, size.height / 150);
    const center = Offset(75, 75);

    // Concentric circles, drawn outer -> inner.
    for (var i = 0; i < _ringRadii.length; i++) {
      final (s, e) = _ringIntervals[i];
      final p = _phase(s, e, Curves.easeOutBack);
      if (p <= 0) continue;
      canvas.drawCircle(
        center,
        _ringRadii[i] * p.clamp(0.0, 1.2),
        Paint()..color = _ringColors[i],
      );
    }

    // Checkmark: stroke-drawn along the centre line of the original glyph.
    final (cs, ce) = _checkInterval;
    final cp = _phase(cs, ce, Curves.easeOutCubic);
    if (cp <= 0) return;

    final full = Path()
      ..moveTo(62.6, 74.3)
      ..lineTo(70.9, 82.6)
      ..lineTo(87.4, 66.1);

    final Path partial = Path();
    for (final PathMetric m in full.computeMetrics()) {
      partial.addPath(m.extractPath(0, m.length * cp), Offset.zero);
    }

    canvas.drawPath(
      partial,
      Paint()
        ..color = _checkColor
        ..style = PaintingStyle.stroke
        ..strokeWidth =
            3.36 // matches the SVG glyph thickness
        ..strokeCap = StrokeCap.butt
        ..strokeJoin = StrokeJoin.miter,
    );
  }

  @override
  bool shouldRepaint(_SuccessPainter old) => old.t != t;
}

/// Quick demo screen with a replay button.
class SuccessTrackingDemo extends StatefulWidget {
  const SuccessTrackingDemo({super.key});

  @override
  State<SuccessTrackingDemo> createState() => _SuccessTrackingDemoState();
}

class _SuccessTrackingDemoState extends State<SuccessTrackingDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SuccessTrackingAnimation(size: 200, controller: _c),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => _c.forward(from: 0),
              child: const Text('Replay'),
            ),
          ],
        ),
      ),
    );
  }
}
