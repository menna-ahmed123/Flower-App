
import 'dart:math';

import 'package:flutter/material.dart';

class AnimationCard extends CustomPainter {
  final double progress;

  AnimationCard({
    required this.progress,
  });

  static final Random _random = Random(10);

  static final List<_Particle> _particles = List.generate(
    90,
    (index) {
      return _Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        dx: 10 + _random.nextDouble() * 70,
        dy: -50 + _random.nextDouble() * 100,
        size: 1.5 + _random.nextDouble() * 3,
        delay: _random.nextDouble() * 0.5,
      );
    },
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final particle in _particles) {
      if (progress < particle.delay) continue;

      final particleProgress =
          ((progress - particle.delay) / (1 - particle.delay))
              .clamp(0.0, 1.0);

      final startX = particle.x * size.width;
      final startY = particle.y * size.height;

      final x = startX + particle.dx * particleProgress;
      final y = startY + particle.dy * particleProgress;

      paint.color = Colors.black.withOpacity(
        1 - particleProgress,
      );

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, y),
          width: particle.size,
          height: particle.size,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant AnimationCard oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}

class _Particle {
  final double x;
  final double y;
  final double dx;
  final double dy;
  final double size;
  final double delay;

  const _Particle({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.size,
    required this.delay,
  });
}