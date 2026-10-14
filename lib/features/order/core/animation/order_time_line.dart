import 'package:flutter/material.dart';

class AnimatedOrderTimeline extends StatelessWidget {
  final int currentStep;
  final List<({String title, String time})> steps;

  const AnimatedOrderTimeline({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  static const activeColor = Color(0xFFE91E63);

  static const titleStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const currentTitleStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
  static const timeStyle =
      TextStyle(fontSize: 14, color: Color(0xFF757575));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) {
        return _TimelineRow(
          title: steps[i].title,
          time: steps[i].time,
          isLast: i == steps.length - 1,
          isDone: i < currentStep,
          isCurrent: i == currentStep,
          isReached: i <= currentStep,
        );
      }),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final String title, time;
  final bool isLast, isDone, isCurrent, isReached;

  const _TimelineRow({
    required this.title,
    required this.time,
    required this.isLast,
    required this.isDone,
    required this.isCurrent,
    required this.isReached,
  });

  @override
  Widget build(BuildContext context) {
    const active = AnimatedOrderTimeline.activeColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                // Circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: isReached ? active : Colors.grey,
                      width: 2.5,
                    ),
                  ),
                  child: isCurrent
                      ? const Center(child: _PulsingDot())
                      : isDone
                      ? const Icon(Icons.check, size: 16, color: active)
                      : null,
                ),
                // Line that fills
                if (!isLast)
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(end: isDone ? 1.0 : 0.0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      builder: (context, value, _) {
                        return CustomPaint(
                          size: const Size(2, double.infinity),
                          painter: _LinePainter(progress: value),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: isReached ? 1 : 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: isCurrent
                          ? AnimatedOrderTimeline.currentTitleStyle
                          : AnimatedOrderTimeline.titleStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: AnimatedOrderTimeline.timeStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final double progress;
  _LinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width / 2;
    final grey = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;
    final pink = Paint()
      ..color = AnimatedOrderTimeline.activeColor
      ..strokeWidth = 2;

    canvas.drawLine(Offset(x, 0), Offset(x, size.height), grey);
    canvas.drawLine(Offset(x, 0), Offset(x, size.height * progress), pink);
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.progress != progress;
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.7, end: 1.0)
          .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
      child: Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AnimatedOrderTimeline.activeColor,
        ),
      ),
    );
  }
}